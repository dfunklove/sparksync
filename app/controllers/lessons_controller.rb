class LessonsController < ApplicationController
  before_action :logged_in_user
  before_action :teacher_user, only: [:new, :create, :checkout, :finishCheckout]
  before_action :admin_user, only: :index

  def new
  	@lesson = Lesson.new
  	@student = Student.new
  	@school = School.new
  	@allSchools = School.all

    open_lesson = current_user.lessons_in_progress.first
    if (open_lesson)
      @lesson = open_lesson
      session[:lesson_id] = open_lesson.id
      flash.now[:danger] = 'Please finish open lesson before starting a new one'
      render "checkout"
    end
  end

  def index
    store_location
    school_id = params[:id]

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

    @showstudent = true
    @showschool = true
    @showteacher = true
    @showhours = true

    sql = "select users.first_name, users.last_name as teacher_last, "
    sql += "time_in, time_out, progress, behavior, notes, brought_instrument, "
    sql += "brought_books, name, students.first_name, "
    sql += "students.last_name as student_last, user_id, student_id "
    sql += "from users inner join lessons on users.id = lessons.user_id "
    sql += "inner join students on lessons.student_id = students.id "
    sql += "inner join schools on students.school_id = schools.id "
    sql += "where time_out is not null"
    sql += " and ? < time_in and time_in < ? "
    @lessons = Lesson.find_by_sql([sql, 
        @dateview.start_date.to_s,  @dateview.end_date.to_s])
    if session[:sortcol]
      sortcol = session[:sortcol]
      # case by case as sorting by student' slast name or school name is not
      # straightforward
      if sortcol == "Student"
        @lessons = @lessons.sort_by(&:student_last)
      elsif sortcol == "Date"
        @lessons = @lessons.sort_by(&:time_in).reverse! 
      elsif sortcol == "School"
        @lessons = @lessons.sort_by(&:name)
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
    respond_to do |format|
      format.html
      format.xls 
    end
  end


  def create
    begin
    	@lesson = Lesson.new(lesson_params)
      @student = Student.new(student_params)
      @lesson.student = @student
      @school = School.find_by(school_params)
      @lesson.school = @school
    rescue
      @lesson ||= Lesson.new
      @student ||= Student.new
      @school ||= School.new
    end

    if @school.valid? && !@student.first_name.empty? && !@student.last_name.empty?
      # if student exists in db get all the column values
      # if student not in db prompt user to see if they want to create
      harrys = Student.where('"last_name" ilike ?', @student.last_name + "%").where('"first_name" ilike ?', @student.first_name + "%").where( school_id: @school.id)
      @stdnt_lookedup = harrys.first
      nharrys = harrys.count

      if @stdnt_lookedup
   	    @lesson.student = @stdnt_lookedup
        puts "number of students " + nharrys.to_s
        if nharrys > 1
          @lesson.errors.add(
            :base,
            :first_name_or_last_name_ambiguous,
            message: "Need to spell out entire name")
        end
      elsif params[:new_student]
        @student.school = @school
        @student.activated = true
        @student.save
        @lesson.student = @student
        flash[:info] = "Created new student #{@student.first_name} #{@student.last_name} at #{@student.school.name}" 
      else
        @lesson.errors.add(
          :base,
          :not_found_in_database,
          message: 'No student by that name at that school. Check "new student" if you wish to add a new student to database, otherwise correct spelling or school')

      end
    end

    @lesson.school = @school
    @lesson.teacher = current_user
    @lesson.time_in = Time.now

    # check errors count first or custom errors get cleared
  	if @lesson.errors.count == 0 && @lesson.save
	  	session[:lesson_id] = @lesson.id
	  	redirect_to "/lessons/checkout"
  	else
	  	@allSchools = School.all
  		render 'new'
  	end
  end

  # leaving checkin page, going to checkout page
  def checkout
  	if !session[:lesson_id]
  		redirect_to root_url
  	end
  	@lesson = Lesson.find(session[:lesson_id])
  end

  # leaving checkout page, returning to checkin page
  def finishCheckout
  	if !session[:lesson_id]
  		redirect_to root_url
  	end
    @lesson = Lesson.find(session[:lesson_id])
  	temp_params = lesson_params
    if (temp_params[:behavior] == nil)
      @lesson.errors.add(
        :base,
        :behavior_missing,
        message: "Behavior can't be blank")
    end
    if (temp_params[:progress] == nil)
      @lesson.errors.add(
        :base,
        :progress_missing,
        message: "Progress can't be blank")
    end

    temp_params[:time_out] = Time.now
  	if @lesson.errors.count == 0 && @lesson.update_attributes(temp_params)
  		session.delete(:lesson_id)
      redirect_to root_url
  	else
      render 'checkout'
  	end
  end

  def sort
    # TODO how do you toggle between asc and desc?
    session[:sortcol] = params[:sortcol]
    # redirecting, you execute the entire action from start
    redirect_to session[:forwarding_url]
  end

  private 
  def lesson_params
  	params.require(:lesson).permit(:time_in, :time_out, :brought_instrument, :brought_books,
  		:progress, :behavior, :notes)
  end

  def student_params
  	params.require(:student).permit(:first_name, :last_name)
  end

  def school_params
  	params.require(:school).permit(:name)
  end

  def dateview_params
    params.require(:dateview).permit(:start_date, :end_date)
  end

  def teacher_user
    return if current_user.teacher?
    redirect_to(root_url) 
  end
end
