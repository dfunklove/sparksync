class TeachersController < UsersController
  # filter which of these methods can be used
  # only allow logged in admin to create or update a teacher
  before_action :logged_in_user, only: [:new, :create, :update, :delete, :show]
  before_action :admin_user, only: [:new, :create, :update, :delete]
  before_action :correct_user, only: :show

  def show
    store_location
    teacher_id = params[:id]
    @teacher = Teacher.find(teacher_id)

    if session[:changet]
      @title = session[:changet] 
    else 
      @title = "Lessons" # default
    end

    @dateview = current_dateview
    if @title == "Hours"

      @logins = Login.where(user_id: teacher_id).where(time_out: (@dateview.start_date..@dateview.end_date)) 
  
      @tot_hours = 0
      @logins.each do |login|
        @tot_hours += login[:time_out] - login[:time_in]
      end
      # convert seconds to hours
      @tot_hours = @tot_hours/3600
      @what_table = "hours_table"
    else
      # title and what column depend on user and in the case
      # of admin, what view she wants
      # nobody but admin and a particular teacher has any business
      # doing a teacher/show 
      # can you do the sorting after the db fetch? it would
      # be preferable in order to sort on multiple columns

      @showstudent = true
      @showschool = true
      @showteacher = false
      @showhours = true

      @lessons = Lesson.find_by_teacher(teacher_id, @dateview.start_date, @dateview.end_date)
      if session[:sortcol]
        sortcol = session[:sortcol]
        # case by case as sorting by student' slast name or school name is not
        # straightforward
        if sortcol == "Student"
          @lessons = @lessons.sort_by(&:last_name)
        elsif sortcol == "Date"
          @lessons = @lessons.sort_by(&:time_in).reverse! 
        elsif sortcol == "School"
          @lessons = @lessons.sort_by(&:name)
        elsif sortcol == "Progress"
          @lessons = @lessons.sort_by(&:progress)
        elsif sortcol == "Behavior"
          @lessons = @lessons.sort_by(&:behavior)
        end
      else
        @lessons = @lessons.sort_by(&:time_in).reverse! 
      end
      @tot_hours = 0
      @lessons.each do |lesson|
        @tot_hours += lesson[:time_out] - lesson[:time_in]
      end
      # convert seconds to hours
      @tot_hours = @tot_hours/3600
      @what_table = "lessons/completed_table"
    end
  end

  def change_table
    changet = params[:changet]
    if changet == "Hours"
      session[:changet] = changet = "Lessons"
    else 
      session[:changet] = "Hours"
    end
    redirect_to session[:forwarding_url]
  end

  # new refers to one of the actions generated
  # by resources :teachers in config/routes.rb
  def new
    store_location
    
    if session[:changev]
      @changev = session[:changev] 
    else 
      @changev = "Active"
    end

    # @teachers and @teacher are variables provided
    # to the new.html.erb view
    @teachers = find_right_teachers
    @teacher = Teacher.new
    @delete_warning = "Deleting this teacher will delete all his/her hours records as well and is irreversible. Are you sure?"
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

  def create
    @teacher = Teacher.new(teacher_params)
    genword = genpassword(@teacher)
    @teacher.activated = true
    if @teacher.save
      @teacher.send_welcome(@teacher.id)
      redirect_to new_teacher_path
    else
      @teachers = find_right_teachers
      if session[:changev]
        @changev = session[:changev] 
      else 
        @changev = "Active"
      end
      render 'new'
    end
  end

  def update
    teacher_id = params[:id]
    @teacher = Teacher.find(teacher_id)
    if params[:modify]
      puts "modify"
      # won't work without password
      genword = genpassword(@teacher)
      if Teacher.update(@teacher.id,
                        first_name: teacher_params[:first_name],
                        last_name: teacher_params[:last_name],
                        email: teacher_params[:email],
                        activated: true,
                        password: genword)
        @teacher.send_password_reset_email
      
        redirect_to new_teacher_path
      else
        @teachers = find_right_teachers
        if session[:changev]
          @changev = session[:changev] 
        else 
          @changev = "Active"
        end
        render 'new'
      end
    elsif params[:delete]
      puts "delete"
      teacher_id = @teacher.id 
      who = Teacher.find(teacher_id)
      if who.activated
        genword = genpassword(who)
        # don't actually delete, set unactivated
        if who.update( activated: false,
                       password: genword)
          redirect_to new_teacher_path
        else
          @teachers = find_right_teachers
          if session[:changev]
            @changev = session[:changev] 
          else 
            @changev = "Active"
          end
          render 'new'
        end
      else
        if who.delete
          redirect_to new_teacher_path
        else
          @teachers = find_right_teachers
          if session[:changev]
            @changev = session[:changev] 
          else 
            @changev = "Active"
          end
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
      params.require(:teacher).permit(:first_name, :last_name, :email)
    end
    def dateview_params
      params.require(:dateview).permit(:start_date, :end_date)
    end
    # Confirms the correct user.
    def correct_user
      return if current_user.type == "Admin"
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
