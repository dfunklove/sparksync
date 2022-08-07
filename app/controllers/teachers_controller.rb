class TeachersController < UsersController
  # filter which of these methods can be used
  # only allow logged in admin to create or update a teacher
  before_action :logged_in_user, only: [:index, :create, :update, :delete, :show]
  before_action :admin_user, only: [:index, :create, :update, :delete]
  before_action :correct_user, only: :show

  def show
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
        while lesson.ratings.length < Goal::MAX_PER_STUDENT
          x = Rating.new
          x.goal = Goal.new
          lesson.ratings << x
        end  
      end
      # convert seconds to hours
      @tot_hours = @tot_hours/3600
      @what_table = "lessons/completed_table"
    end
  end

  def change_table
    session[:changet] = params[:changet]
    redirect_to request.referrer
  end

  def index
    @teacher = Teacher.new
    prepare_index
  end

  # prepare everything needed before calling "render 'index'"
  def prepare_index
    @changev = current_visibility
    @teachers = visible_records(Teacher)
    @delete_warning = "Deleting this teacher will delete all his/her hours records as well and is irreversible. Are you sure?"    
  end

  def handle_error
    prepare_index
    render 'index'
  end

  def create
    @teacher = Teacher.new(teacher_params)
    genword = genpassword(@teacher)
    @teacher.activated = true
    if @teacher.save
      @teacher.send_welcome(@teacher.id)
      redirect_to teachers_url
    else
      handle_error
    end
  end

  def update
    teacher_id = params[:id]
    @teacher = Teacher.find(teacher_id)
    success = true
    if params[:modify]
      puts "modify"
      if @teacher.update(first_name: teacher_params[:first_name],
                        last_name: teacher_params[:last_name],
                        email: teacher_params[:email])      
        redirect_to teachers_url
      else
        handle_error
      end
    elsif params[:delete]
      puts "delete"
      if @teacher.activated
        # don't actually delete, set unactivated
        if @teacher.update(activated: false)
          redirect_to teachers_url
        else
          handle_error
        end
      else
        if @teacher.delete
          redirect_to teachers_url
        else
          handle_error
        end
      end
    elsif params[:activate]
      puts "activate"
      if @teacher.update(activated: true)
        redirect_to teachers_url
      else
        handle_error
      end
    elsif params[:reset]
      puts "reset"
      genword = genpassword(@teacher)
      if @teacher.update(password: genword)
        @teacher.send_password_reset_email
        redirect_to teachers_url
      else
        handle_error
      end      
    elsif params[:hours]
      redirect_to teacher_path(teacher_id)
    else
      raise Exception.new('not modify, delete, activate, or reset. who called teacher update?')
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
