class GroupLessonsController < ApplicationController
  before_action :logged_in_user
  before_action :teacher_user, only: [:new, :create, :checkout, :finishCheckout]
  before_action :admin_user, only: :index

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
    elsif !@group_lesson
      @group_lesson = GroupLesson.new

      # populate lessons from students
      @students.each do |student|
        lesson = Lesson.new
        lesson.student = student
        @group_lesson.lessons << lesson
      end

      # add one for writing in a student
      lesson = Lesson.new
      lesson.student = Student.new
      lesson.student.school = School.new
      @group_lesson.lessons << lesson
    end
  end

  def create
    @group_lesson = GroupLesson.new(group_lesson_params)
    @group_lesson.teacher = current_user
    @group_lesson.time_in = Time.now

    # pick only the students/lessons which are selected
    params[:group_lesson][:lessons_attributes].keys.each do |key|
      lesson_data = params[:group_lesson][:lessons_attributes][key]
      if lesson_data["selected"]
        @group_lesson.lessons << Lesson.new(lesson_params(lesson_data))
      end
      if !lesson_data[:student_id]
        # process name and school id into student id
      end
    end

    @group_lesson.lessons.each do |lesson|
      lesson.teacher = current_user
      lesson.time_in = @group_lesson.time_in
    end

    puts "group_lesson.lessons.count=#{@group_lesson.lessons.count}, listing="
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
  	@group_lesson = GroupLesson.find_by_id(session[:group_lesson_id])
    @students = Student.find_by_teacher(current_user.id)
  end

  def finishCheckout
  	if !session[:group_lesson_id]
  		redirect_to root_url
  	end
    @group_lesson = GroupLesson.find(session[:group_lesson_id])
    if @group_lesson.lessons.update_all(time_out: Time.now) && @group_lesson.update_attributes(time_out: Time.now)
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
      params.require(:group_lesson).permit(:notes)
    end

    def lesson_params params
      params.permit(:brought_books, :brought_instrument, :student, :student_id, :school_id)
    end

    def student_params params
      params.require(:student).permit(:first_name, :last_name, :school_id)
    end

    def teacher_user
      return if current_user.teacher?
      redirect_to(root_url) 
    end  
  end
