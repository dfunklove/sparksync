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
      session[:group_lesson_id] = open_group_lesson.id
      flash[:danger] = error_message
      redirect_to "/group_lessons/checkout"
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
    if session[:group_lesson_id]
      logger.warn("create: group lesson already in progress")
  		redirect_to "/group_lessons/checkout"
      return
  	end
    
    group_lesson  = GroupLesson.new
    group_lesson.teacher = current_user

    # Round time to the second to prevent double form submission
    group_lesson.time_in = Time.at((Time.now.to_f).round)

    if params[:group_lesson]

      # pick only the students/lessons which are selected
      params[:group_lesson][:lessons_attributes].keys.each do |key|
        lesson_data = params[:group_lesson][:lessons_attributes][key]
        selected = lesson_data["selected"]
        if selected
          lesson = Lesson.new(lesson_params(lesson_data))
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
        format.js { render '/shared/error', locals: { object: group_lesson } }
      end
    end
  end

  def checkout
  	if !session[:group_lesson_id]
      logger.warn("checkout: no group lesson in progress")
  		redirect_to root_url
      return
  	end
  	@group_lesson = GroupLesson.find_by_id(session[:group_lesson_id])
    @students = Student.find_by_teacher(current_user.id)
    @group_lesson.lessons.each do |lesson|
      lesson.get_goals_from_student
      LessonsHelper::add_empty_ratings(lesson)
    end
  end

  def finishCheckout
  	if !session[:group_lesson_id]
      logger.warn("finishCheckout: no group lesson in progress")
  		redirect_to root_url
      return
    end
    @group_lesson = GroupLesson.find_by_id(session[:group_lesson_id])
    temp_params = group_lesson_params
    temp_params[:time_out] = Time.now

    # Update student goals from ratings
    temp_group_lesson = GroupLesson.new(temp_params)
    temp_group_lesson.lessons.each do |lesson|
      lesson.save_goals_to_student
    end

    respond_to do |format|
      if @group_lesson.errors.count == 0 && @group_lesson.update_attributes(temp_params)
        session.delete(:group_lesson_id)
        if @group_lesson.course
          format.html { redirect_to '/courses' }
        else
          format.html { redirect_to '/group_lessons/new' }
        end
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
      params.permit(:brought_books, :brought_instrument, :student_id, :school_id, :notes,
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
  