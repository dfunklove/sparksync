class GroupLessonsController < ApplicationController
  def index
  end

  def new
    prepare_new
  end

  def prepare_new
    @students = Student.find_by_teacher(current_user.id)

    open_lesson = current_user.group_lessons_in_progress.first
    if open_lesson
      @group_lesson = open_lesson
      session[:group_lesson_id] = open_lesson.id
      flash.now[:danger] = 'Please finish open lesson before starting a new one'
      render "checkout"
    else
      @group_lesson ||= GroupLesson.new
      @group_lesson.lessons << Lesson.new
    end
  end

  def create
    @group_lesson = GroupLesson.new(group_lesson_params)
    @group_lesson.teacher = current_user
    @group_lesson.time_in = Time.now

    @group_lesson.lessons.each do |lesson|
      if !lesson.student_id
        @group_lesson.lessons.delete(lesson)
      end
      lesson.teacher = current_user
    end

    puts "group_lesson.lessons="
    p @group_lesson.lessons

    if @group_lesson.save
      session[:group_lesson_id] = @group_lesson.id
      redirect_to "/group_lessons/checkout"
    else
      prepare_new
      render 'new'
    end
  end

  def checkout
  	if !session[:group_lesson_id]
  		redirect_to root_url
  	end
  	@group_lesson = GroupLesson.find(session[:group_lesson_id])
    @students = Student.find_by_teacher(current_user.id)
  end

  def finishCheckout
  	if !session[:group_lesson_id]
  		redirect_to root_url
  	end
    @group_lesson = GroupLesson.find(session[:group_lesson_id])
  	if @group_lesson.update_attributes(time_out: Time.now)
  		session.delete(:group_lesson_id)
      redirect_to root_url
  	else
      render 'checkout'
  	end
  end

  def update
  end

  def destroy
  end

  private
    def group_lesson_params
      params.require(:group_lesson).permit(:notes, :lessons, lessons_attributes: [:brought_books, :brought_instrument, :student, :student_id, :school_id])
    end

    def lesson_params params
      params = ActionController::Parameters.new(params)
      params.permit(:brought_books, :brought_instrument, :student, :student_id, :school_id)
    end

    def student_params lesson_params
      params = ActionController::Parameters.new(lesson_params)
      params.require(:student).permit(:first_name, :last_name, :school_id)
    end
end
