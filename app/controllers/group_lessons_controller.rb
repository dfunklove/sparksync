class GroupLessonsController < ApplicationController
  before_action :logged_in_user
  before_action :teacher_user, only: [:new, :create, :checkout, :finishCheckout]
  before_action :admin_user, only: :index

  def index
  end

  def new
    @students = Student.find_by_teacher(current_user.id)

    error_message = 'Please finish open lesson before starting a new one'
    open_lesson = current_user.lessons_in_progress.first
    open_group_lesson = current_user.group_lessons_in_progress.first
    if open_group_lesson
      @group_lesson = open_group_lesson
      session[:group_lesson_id] = open_group_lesson.id
      flash.now[:danger] = error_message
      render "checkout"
    elsif open_lesson
      session[:lesson_id] = open_lesson.id
      flash[:danger] = error_message
      redirect_to "/lessons/checkout"
    else
      @group_lesson = GroupLesson.new

      # populate lessons from students
      @students.each do |student|
        lesson = Lesson.new
        lesson.student = student
        @group_lesson.lessons << lesson
      end
    end
  end

  def create
    group_lesson  = GroupLesson.new
    group_lesson.teacher = current_user
    group_lesson.time_in = Time.now

    if params[:group_lesson]

      # pick only the students/lessons which are selected
      params[:group_lesson][:lessons_attributes].keys.each do |key|
        lesson_data = params[:group_lesson][:lessons_attributes][key]
        selected = lesson_data["selected"]
        lesson = Lesson.new(lesson_params(lesson_data))
        lesson.teacher = current_user
        lesson.time_in = group_lesson.time_in
        if selected
          group_lesson.lessons << lesson
        end        
      end
    end

    if group_lesson.lessons.size < 2
      group_lesson.errors.add(
        :base,
        :add_more_students,
        message: "Please select two or more students"
      )
    end

    respond_to do |format|
      if group_lesson.errors.count == 0 && group_lesson.save
        session[:group_lesson_id] = group_lesson.id
        format.html { redirect_to "/group_lessons/checkout" }
      else
        format.js { render 'checkout_error', locals: { object: group_lesson } }
      end
    end
  end

  def addStudent
    row_count = params[:row_count].to_i
    add_student_confirmed = params[:add_student_confirmed]
    lesson_data = params[:group_lesson][:lesson]
    lesson = Lesson.new(lesson_params(lesson_data))
    lesson.time_in = Time.now
    lesson.teacher = current_user
    lesson_in_progress = session[:group_lesson_id]

    confirm_add_student = false
    if !lesson.student_id
      begin
        student = Student.new(student_params lesson_data[:student]  )
        student.school = School.find_by(id: student.school_id) || School.new
      rescue => e
        p e
        student = Student.new
        student.school = School.new
      end
      lesson.student = student
      lesson.school_id = student.school_id

      confirm_add_student = lookup_student_for_lesson(lesson, add_student_confirmed)
    end

    respond_to do |format|
      if confirm_add_student
        format.js { render 'confirm_add_student' }
      elsif lesson_in_progress
        group_lesson = GroupLesson.find_by_id(session[:group_lesson_id])
        lesson.time_in = group_lesson.time_in
        group_lesson.lessons << lesson
        if lesson.valid? && group_lesson.save
          format.js { render 'add_student', locals: { lesson: lesson, lesson_in_progress: lesson_in_progress, total_students: row_count, student_created: add_student_confirmed } }
        else
          format.js { render 'checkout_error', locals: { object: lesson } }
        end
      elsif lesson.valid?
        format.js { render 'add_student', locals: { lesson: lesson, lesson_in_progress: lesson_in_progress, total_students: row_count, student_created: add_student_confirmed } }
      else
        format.js { render 'checkout_error', locals: { object: lesson } }
      end
    end
  end

  # Description: 
  # This method has several responsibilities: 
  #   -Lookup student ID for name and school id
  #   -Add error message on ambiguous lookup
  #   -Create new student
  #   -Indicate the need to confirm before creating new student
  #
  # Inputs
  #   lesson
  #
  # Modifies
  #   confirm_add_student
  #   lesson
  #
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

  def checkout
  	if !session[:group_lesson_id]
  		redirect_to root_url
  	end
  	@group_lesson = GroupLesson.find_by_id(session[:group_lesson_id])
    @students = Student.find_by_teacher(current_user.id)
    @group_lesson.lessons.each do |lesson|
      lesson.student.goals.each do |goal|
        x = Rating.new
        x.goal = goal
        lesson.ratings << x
      end
      while lesson.ratings.length < Goal::MAX_PER_STUDENT
        x = Rating.new
        x.goal = Goal.new
        lesson.ratings << x
      end
    end
  end

  def finishCheckout
  	if !session[:group_lesson_id]
  		redirect_to root_url
    end
    @group_lesson = GroupLesson.find_by_id(session[:group_lesson_id])
    temp_params = group_lesson_params
    temp_params[:time_out] = Time.now
    @group_lesson.lessons.each do |lesson|
      lesson.time_out = temp_params[:time_out]
    end

    # Update student goals from ratings
    temp_group_lesson = GroupLesson.new(temp_params)
    temp_group_lesson.lessons.each do |lesson|
      # Clear the existing goals because we only want the new ones
      lesson.student.goals.clear

      # Get goal id's from the ratings and save them to the student
      lesson.ratings.each do |rating|
        begin
          lesson.student.goals << Goal.find(rating.goal.id) unless rating.goal.nil? or rating.goal.new_record?
        rescue ActiveRecord::RecordInvalid => e
          logger.error(e)
          lesson.errors.add(:goals, e.message)
        end
      end
    end

    respond_to do |format|
      if @group_lesson.errors.count == 0 && @group_lesson.update_attributes(temp_params)
        session.delete(:group_lesson_id)
        format.html { redirect_to '/group_lessons/new' }
      else
        format.html { render action: 'checkout'}
        format.js { render '/shared/error', locals: { object: @group_lesson } }
      end
    end
  end

  def update
  end

  def destroy
  end

  private
    def group_lesson_params
      params.require(:group_lesson).permit(:id, :notes, lessons_attributes: 
          [:id, :brought_books, :brought_instrument, :student_id, :school_id, :notes, 
          ratings_attributes: [:id, :score, :goal_id],
          student_attributes: [:id, :permissions]])
    end

    def lesson_params params
      params.permit(:brought_books, :brought_instrument, :student, :student_id, :school_id, :notes,
          ratings_attributes: [:id, :score, :goal_id],
          student_attributes: [:id, :permissions])
    end

    def student_params params
      params.permit(:first_name, :last_name, :school_id, :permissions)
    end

    def teacher_user
      return if current_user.teacher?
      redirect_to(root_url) 
    end  
  end
  