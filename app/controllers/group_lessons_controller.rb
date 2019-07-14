class GroupLessonsController < ApplicationController
  def index
  end

  def new
    @group_lesson = GroupLesson.new
    prepare_new
  end

  def prepare_new
    @students = Student.find_by_teacher(current_user.id)

    open_lesson = current_user.lessons_in_progress.first
    if open_lesson
      @lesson = open_lesson
      session[:lesson_id] = open_lesson.id
      flash.now[:danger] = 'Please finish open lesson before starting a new one'
      render "checkout"
    else
      @lesson ||= Lesson.new
    end
    if !@lesson.student
      @lesson.student = Student.new
    end
  end

  def create
  end

  def checkout
    @lesson = Lesson.new
    @students = Student.find_by_teacher(current_user.id)
    @lesson.student = Student.new
  end

  def finishCheckout
  end

  def update
  end

  def destroy
  end
end
