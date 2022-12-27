class LessonsController < ApplicationController
  before_action :logged_in_user
  before_action :teacher_user, only: [:new, :create, :checkout, :finishCheckout]

  def new
    student_id=params[:s_id]
    if student_id
      # teachers can only select from students they have taught before
      # this prevents users from harvesting student names by putting id's in the url
      allowed_students = Student.find_by_teacher(current_user.id)
      @student = allowed_students.find_by(id: student_id)
      if !@student
        flash.now[:danger] = 'Invalid student id.  Please enter data manually.'
      end
    end
    if @student
      @school = @student.school
      @allSchools = [@school]
    else
      @student = Student.new
      @school = School.new
      @allSchools = School.where(activated: true)
    end
    prepare_new
  end

  def prepare_new
    if not handle_open_lesson
      @students = Student.find_by_teacher(current_user.id)
      @lesson = Lesson.new
      if !@lesson.student
        @lesson.student = Student.new
      end
    end
  end

  def index
    school_id = params[:id]

    prepare_index
  end

  def prepare_index
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

    @schools = School.where("activated=?", true).order(:name).collect{|c| [c.name, c.id]}
    @teachers = Teacher.where("activated=?", true).order(:last_name).collect{|t| ["#{t.first_name} #{t.last_name}", t.id]}
    @students = Student.where("activated=?", true).order(:last_name).collect{|s| ["#{s.first_name} #{s.last_name}", s.id]}
    @delete_warning = "Deleting this lesson record is irreversible. Are you sure?"
    @start_date = params[:start_date] || LessonsHelper::default_start_date
    @end_date = params[:end_date] || LessonsHelper::default_end_date
    if current_user.teacher?
      @messons = Lesson.find_by_teacher(current_user.id, @start_date, @end_date)
    else
      @messons = Lesson.find_by_date(@start_date, @end_date)
    end
    if session[:sortcol]
      sortcol = session[:sortcol]
      # case by case as sorting by student' slast name or school name is not
      # straightforward
      # puts "final sortcol " + sortcol
      if sortcol == "Student"
        @messons = @messons.sort_by(&:student_last)
      elsif sortcol == "Date" || sortcol == "Time In"
      @messons = @messons.sort_by(&:time_in).reverse! 
      elsif sortcol == "School"
        @messons = @messons.sort_by(&:name)
      elsif sortcol == "Teacher"
        @messons = @messons.sort_by(&:teacher_last)
      elsif sortcol == "Progress"
        @messons = @messons.sort_by(&:progress)
      elsif sortcol == "Behavior"
        @messons = @messons.sort_by(&:behavior)
      end
    else
      @messons = @messons.sort_by(&:time_in).reverse! 
    end
    @tot_hours = 0
    @messons.each do |lesson|
      @tot_hours += lesson[:time_out] - lesson[:time_in]
      LessonsHelper::add_empty_ratings(lesson)
    end
    # convert seconds to hours
    @tot_hours = @tot_hours/3600
    respond_to do |format|
      format.html
      format.xls 
    end
  end

  def handle_index_error
    prepare_index
    render 'index'
  end

  def muckwithdate(whatdate)
    turn2date = DateTime.strptime(whatdate, '%l:%M %p %m-%d-%Y')
    screwyrailstime = turn2date.strftime('%l:%M %p %Y-%m-%d')
    intimezoneDST = screwyrailstime.in_time_zone('Central Time (US & Canada)')
  end

  def update
    @lesson = Lesson.find(params[:id])
    if current_user.teacher? and not @lesson.user_id == current_user.id
      redirect_to '/lessons'
      return
    end
    temp_params = lesson_params
    if params[:modify]
      logger.error("temp_params: #{temp_params}")
      logger.error("lesson.attributes: #{@lesson.attributes}")
      if @lesson.errors.count == 0
        @lesson.update_attributes(temp_params)
      end
    elsif params[:delete]
      @lesson.delete
    else
      raise Exception.new('not modify or delete. who called lesson update?')
    end

    respond_to do |format|
      if @lesson.errors.count == 0
        format.html { redirect_to '/lessons' }
      else
        prepare_index
        format.html { render action: 'index' }
        format.js { render '/shared/error', locals: { object: @lesson } }
      end
    end
  end

  # TODO migrate this to JS like group_lesson
  def create
    add_student_confirmed = params[:add_student_confirmed]
    lesson = Lesson.new(lesson_params)
    lesson.teacher = current_user

    # Round time to the second to prevent double form submission
    lesson.time_in = Time.at((Time.now.to_f).round)

    confirm_add_student = false
    if !lesson.student_id
      begin
        student = Student.new(student_params)
        student.school = School.find_by(id: student.school_id) || School.new
      rescue => e
        p e
        student = Student.new
        student.school ||= school.new
      end
      lesson.student = student
      lesson.school_id = student.school_id

      confirm_add_student = lookup_student_for_lesson lesson, add_student_confirmed
    end

    # check errors count first or custom errors get cleared
    respond_to do |format|
      if confirm_add_student
        format.js { render 'confirm_add_student' }
      elsif lesson.errors.count == 0 && lesson.save
        session[:lesson_id] = lesson.id
        format.html { redirect_to "/lessons/checkout" }
      else
        format.js { render '/shared/error', locals: { object: lesson } }
      end
    end
end

  def lookup_student_for_lesson lesson, add_student_confirmed
    student = lesson.student
    school = lesson.student.school
    if school.valid? && !student.first_name.empty? && !student.last_name.empty?
      # if student exists in db get all the column values
      # if student not in db prompt user to see if they want to create
      results = Student.find_by_name(student.first_name, student.last_name, school.id)

      if results.count == 1
        lesson.student = results.first
      elsif results.count > 1
        lesson.errors.add(
          :base,
          :first_name_or_last_name_ambiguous,
          message: "Need to spell out entire name")
      else
        if add_student_confirmed
          student.save
        else
          confirm_add_student = true
        end
      end
    end
    confirm_add_student
  end

  # leaving checkin page, going to checkout page
  def checkout
  	if !session[:lesson_id]
  		redirect_to root_url
  	end
  	@lesson = Lesson.find(session[:lesson_id])
    @lesson.get_goals_from_student
    LessonsHelper::add_empty_ratings(@lesson)
  end

  # leaving checkout page, returning to checkin page
  def finishCheckout
  	if !session[:lesson_id]
  		redirect_to root_url
  	end
    @lesson = Lesson.find(session[:lesson_id])
  	temp_params = lesson_params
    temp_params[:time_out] = Time.now

    # Update student goals from ratings
    temp_lesson = Lesson.new(lesson_params)
    temp_lesson.student = @lesson.student
    temp_lesson.save_goals_to_student

    respond_to do |format|
      if @lesson.errors.count == 0 && @lesson.update_attributes(temp_params)
        session.delete(:lesson_id)
        format.html { redirect_to '/lessons/new' }
      else
        format.html { render action: 'checkout' }
        format.js { render '/shared/error', locals: { object: @lesson } }
      end
    end
  end

  def sort
    # TODO how do you toggle between asc and desc?
    session[:sortcol] = params[:sortcol]
    # puts "sortcol " + session[:sortcol]
    # redirecting, you execute the entire action from start
    redirect_to request.referrer
  end

  private 
  def lesson_params
  	params.require(:lesson).permit(:id, :time_in, :time_out, :brought_instrument, :brought_books,
      :progress, :behavior, :notes, :user_id, :school_id, :student_id, ratings_attributes: [:id, :score, :goal_id])
  end

  def student_params
  	params.require(:lesson).require(:student_attributes).permit(:first_name, :last_name, :school_id)
  end

  def school_params
  	params.require(:school).permit(:name)
  end

  def teacher_user
    return if current_user.teacher?
    redirect_to(root_url) 
  end
end
