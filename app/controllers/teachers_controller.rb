class TeachersController < ApplicationController
  # filter which of these methods can be used
  # only allow logged in admin to create or update a teacher
  before_action :logged_in_user, only: [:new, :create, :update, :delete, :show]
  before_action :admin_user, only: [:new, :create, :update, :delete, :show]

  def show
    store_location
    teacher_id = params[:id]
    @teacher = Teacher.find(teacher_id)
    @tot_hours = 0
    if session[:dv_id]
      puts "subsequent view"
      @dateview = Dateview.find(session[:dv_id])
      puts "dateview errors after finding " + @dateview.errors.messages.to_s
      # error is not there, you could not save it and did not save it with errors
      # you cannot post to a "show", that was why you made a dateviews model and
      # controller. perhaps you need a dateviews view after all just to show
      # error so it can be corrected
    else
      puts "first view"
      # set default for the preceding week including today
      e_date = Time.now.midnight + 24*60*60
      s_date = e_date - 6*24*60*60
      puts "dateview new end_date " + e_date.to_s + " start_date " + s_date.to_s
      @dateview = Dateview.new(end_date: e_date, start_date: s_date)
      puts "dateview errors " + @dateview.errors.messages.to_s

      if @dateview.errors.count == 0 && @dateview.save
        session[:dv_id] = @dateview.id
        puts "saving session dv_id " + session[:dv_id].to_s
      else
        raise Exception.new("Not able to save default dateview")
      end
    end

    @logins = Login.where(user_id: teacher_id).where(time_out: (@dateview.start_date..@dateview.end_date)) 

    @logins.each do |login|
      @tot_hours += login[:time_out] - login[:time_in]
    end
    # convert seconds to hours
    @tot_hours = @tot_hours/3600
  end

  # new refers to one of the actions generated
  # by resources :teachers in config/routes.rb
  def new
    # @teachers and @teacher are variable provided
    # to the new.html.erb view
    @teachers = Teacher.all
    @teacher = Teacher.new
  end

  def genpassword
    genword = (10000000 + rand(10000000)).to_s
    puts "password " + genword
    @teacher.password =  genword
		@teacher.password_confirmation = genword
  end

  def create
    @teacher = Teacher.new(teacher_params)
    genword = genpassword
    if @teacher.save
      #TODO send email
      redirect_to new_teacher_path
    else
      @teachers = Teacher.all
      render 'new'
    end
  end

  def update
    teacher_id = params[:id]
    @teacher = Teacher.find(teacher_id)
    if params[:welcome]
      genword = genpassword
      if Teacher.update(teacher_id, password: genword)
        #TODO send email
        redirect_to new_teacher_path
      else
        @teachers = Teacher.all
        render 'new'
      end
    elsif params[:modify]
      puts "modify"
      # won't work without password
      genword = genpassword
      if Teacher.update(@teacher.id,
                        firstName: teacher_params[:firstName],
                        lastName: teacher_params[:lastName],
                        email: teacher_params[:email],
                        password: genword)
        #TODO send email
        redirect_to new_teacher_path
      else
        @teachers = Teacher.all
        render 'new'
      end
    elsif params[:delete]
      puts "delete"
      #TODO don't actually delete, set unactivated
      if Teacher.delete(teacher_id)
        redirect_to new_teacher_path
      else
        @teachers = Teacher.all
        render 'new'
      end
    elsif params[:hours]
      redirect_to teacher_path(teacher_id)
    else
      raise Exception.new('not welcome, modify or delete. who called teacher update?')
    end
  end

  private
    def teacher_params
      params.require(:teacher).permit(:firstName, :lastName, :email)
    end
    def dateview_params
      params.require(:dateview).permit(:start_date, :end_date)
    end
end
