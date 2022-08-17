class CoursesController < ApplicationController
  before_action :logged_in_user
  before_action :teacher_user

  def new
    @title = "New Course"
    @course = Course.new
    render 'show'
  end

  def show
    @title = "Edit Course"
    @course = Course.find_by(id: params[:id])
  end

  def create
    course = Course.new(course_params)
    course.teacher = current_user

    respond_to do |format|
      if course.save
        format.html { redirect_to "/courses" }
      else
        format.js { render '/shared/error', locals: { object: course } }
      end
    end
  end

  def update
    course = Course.find_by_id(params[:id])

    respond_to do |format|
      if course.update_attributes(course_params)
        format.html { redirect_to "/courses" }
      else
        format.js { render '/shared/error', locals: { object: course } }
      end
    end
  end

  def index
    courses = Course.where(user_id: current_user.id)
    @current_courses = courses.where("end_date IS ?", nil).or(courses.where("end_date >= ?", Date.today))
    @past_courses = courses.where("end_date < ?", Date.today)
  end

  def teach
    group_lesson = GroupLesson.new
    group_lesson.teacher = current_user

    # Round time to the second to prevent double form submission
    group_lesson.time_in = Time.at((Time.now.to_f).round)

    course = Course.find_by(id: params[:id])
    course.students.each do |student|
      lesson = Lesson.new
      lesson.student = student
      lesson.school = course.school
      lesson.teacher = group_lesson.teacher
      lesson.time_in = group_lesson.time_in
      group_lesson.lessons << lesson
    end

    respond_to do |format|
      if group_lesson.save
        session[:group_lesson_id] = group_lesson.id
        format.html { redirect_to "/group_lessons/checkout" }
      else
        flash[:danger] = group_lesson.errors.messages.reduce("") { |big, small| "#{big}, #{small}" }
        format.html { redirect_to "/courses" }
      end
    end
  end

  def teacher_user
    return if current_user.teacher?
    redirect_to(root_url) 
  end  

  def course_params
    params.require(:course).permit(:id, :name, :start_date, :end_date, :school_id, student_ids: [])
  end
end
