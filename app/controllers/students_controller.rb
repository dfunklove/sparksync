class StudentsController < ApplicationController
  # filter which of these methods can be used
  # only allow logged in admin to create or update a student
  before_action :logged_in_user, only: [:new, :create, :update, :delete, :show]
  before_action :admin_user, only: [:new, :create, :update, :delete]
  before_action :correct_user, only: [:show]

  def show
    store_location
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

    # title and what column depend on user and in the case
    # of admin, what view she wants
    # nobody but admin and a particular partner has any business
    # doing a school/show
    # can you do the sorting after the db fetch? it would
    # be preferable in order to sort on multiple columns

    @showstudent = false
    @showschool = true
    @showteacher = true
    @showhours = true

    sql = "select users.first_name, users.last_name as teacher_last, "
    sql += "time_in, time_out, progress, behavior, notes, brought_instrument, "
    sql += "brought_books, schools.name, user_id, student_id "
    sql += "from users inner join lessons on users.id = lessons.user_id"
    sql += " inner join students on lessons.student_id = students.id"
    sql += " inner join schools on students.school_id = schools.id where "
    sql += " time_out is not null and lessons.student_id = " + @student_id 
    sql += " and ? < time_in and time_in < ? "
    @lessons = Lesson.find_by_sql([sql, 
        @dateview.start_date.to_s,  @dateview.end_date.to_s])
    if session[:sortcol]
      sortcol = session[:sortcol]
      # case by case as sorting by student' slast name or school name is not
      # straightforward
      if sortcol == "School"
        @lessons = @lessons.sort_by(&:name)
      elsif sortcol == "Date"
        @lessons = @lessons.sort_by(&:time_in).reverse! 
      elsif sortcol == "Teacher"
        @lessons = @lessons.sort_by(&:teacher_last)
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

  # new refers to one of the actions generated
  # by resources :students in config/routes.rb
  def new
    store_location
    
    if session[:changev]
      @changev = session[:changev] 
    else 
      @changev = "Active"
    end

    # @students and @student are variables provided
    # to the new.html.erb view
    @students = find_right_students
    @student = Student.new
  end

  def find_right_students
    if @changev == "Active"
      Student.where(activated: true)
    elsif @changev == "Inactive"
      Student.where(activated: false)
    else
      Student.all
    end
  end
 
  def create
    @student = Student.new(student_params)
    @student.activated = true
    if @student.save
      redirect_to new_student_path
    else
      @students = find_right_students
      render 'new'
    end
  end

  def update
    student_id = params[:id]
    @student = Student.find(student_id)
    if params[:modify]
      puts "modify"
      if Student.update(@student.id,
                        school_id: student_params[:school_id],
                        first_name: student_params[:first_name],
                        last_name: student_params[:last_name],
                        activated: true)
        redirect_to new_student_path
      else
        @students = find_right_students
        render 'new'
      end
    elsif params[:delete]
      puts "delete"
      student_id = @student.id 
      who = Student.find(student_id)
      if who.activated
        # don't actually delete, set unactivated
        if who.update( activated: false)
          redirect_to new_student_path
        else
          @students = find_right_students
          render 'new'
        end
      else
        if who.delete
          redirect_to new_student_path
        else
          @students = find_right_students
          render 'new'
        end
      end
    elsif params[:hours]
      redirect_to student_path(student_id)
    else
      raise Exception.new('not welcome, modify or delete. who called student update?')
    end
  end

  private
    def student_params
      params.require(:student).permit(:first_name, :last_name, :email, :school_id)
    end
    def correct_user
      @student_id = params[:id]
      @student = Student.find(@student_id)
      return if current_user.admin?
      return if current_user.partner? && 
          current_user.school_id == @student.school_id
      evertaught = 
        Lesson.where(user_id: current_user.id).find_by(student_id: @student_id)   
      return if current_user.teacher? && evertaught
      redirect_to root_url
    end

end
