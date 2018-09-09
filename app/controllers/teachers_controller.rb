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
      @dateview = Dateview.find(session[:dv_id])
    else
      # set default for the preceding week including today
      e_date = Time.now.midnight + 24*60*60
      s_date = e_date - 6*24*60*60
      @dateview = Dateview.new(end_date: e_date, start_date: s_date)

      if @dateview.errors.count == 0 && @dateview.save
        session[:dv_id] = @dateview.id
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
    # @teachers and @teacher are variables provided
    # to the new.html.erb view
    
    if session[:changev]
      @changev = session[:changev] 
    else 
      @changev = "Active"
    end
    @teachers = find_right_teachers
    @teacher = Teacher.new
  end

  def find_right_teachers
    if @changev == "Active"
      Teacher.where(activated: true)
    elsif @changev == "Inactive"
      Teacher.where(activated: false)
    else
      Teacher.all
    end
  end
 
  def change_view
    changev = params[:changev]
    if changev == "Active"
      session[:changev] = changev = "All"
    elsif changev == "All"
      session[:changev] = changev = "Inactive"
    else 
      session[:changev] = "Active"
    end
    redirect_to new_teacher_path
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
    @teacher.activated = true
    if @teacher.save
      #TODO send email
      redirect_to new_teacher_path
    else
      @teachers = find_right_teachers
      render 'new'
    end
  end

  def update
    teacher_id = params[:id]
    @teacher = Teacher.find(teacher_id)
    if params[:modify]
      puts "modify"
      # won't work without password
      genword = genpassword
      if Teacher.update(@teacher.id,
                        firstName: teacher_params[:firstName],
                        lastName: teacher_params[:lastName],
                        email: teacher_params[:email],
                        activated: true,
                        password: genword)
        #TODO send email
        redirect_to new_teacher_path
      else
        @teachers = find_right_teachers
        render 'new'
      end
    elsif params[:delete]
      puts "delete"
      teacher_id = @teacher.id 
      who = Teacher.find(teacher_id)
      if who.activated
        genword = genpassword
        # don't actually delete, set unactivated
        if who.update( activated: false,
                       password: genword)
          redirect_to new_teacher_path
        else
          @teachers = find_right_teachers
          render 'new'
        end
      else
        if who.delete
          redirect_to new_teacher_path
        else
          @teachers = find_right_teachers
          render 'new'
        end
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
