class CoursesController < ApplicationController
  before_action :logged_in_user
  before_action :teacher_user

  def new
    @title = "New Course"
    @course = Course.new
    render 'show'
  end

  def clone
    course = Course.find_by(id: params[:id])
    attrs = course.attributes
    attrs.delete('id')
    attrs.delete('created_at')
    attrs.delete('updated_at')

    # make a unique name
    names = Course.select(:name).reduce([]) { |names, course| names << course.name }
    name = ""
    i = 1
    loop do
      name = "#{attrs['name']} (#{i})"
      break if not names.include? name
      i += 1
    end
    attrs['name'] = name

    course = Course.new(attrs)
    course.save
    redirect_to "/courses"
  end

  def create
    course = Course.new(course_params)
    course.teacher = current_user
    if !params[:course][:student_ids]
      course.errors.add(
        :base,
        :add_more_students,
        message: "Please select two or more students"
      )
    end

    respond_to do |format|
      if course.errors.count == 0 && course.save
        format.html { redirect_to "/courses" }
      else
        format.js { render '/shared/error', locals: { object: course } }
      end
    end
  end

  def destroy
    begin
      Course.destroy(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      logger.error(e)
    end
    redirect_to "/courses"
  end

  def show
    @title = "Edit Course"
    @course = Course.find_by(id: params[:id])
  end

  def update
    course = Course.find_by(id: params[:id])
    if !params[:course][:student_ids]
      course.errors.add(
        :base,
        :add_more_students,
        message: "Please select two or more students"
      )
    end

    # This only gets triggered when the user adds duplicate students
    begin
      course.attributes = course_params
    rescue ActiveRecord::RecordInvalid => e
      logger.error(e)
      course.errors.add(:base, :unknown_error, message: e.message)
    end

    respond_to do |format|
      if course.errors.count == 0 && course.save
        format.html { redirect_to "/courses" }
      else
        format.js { render '/shared/error', locals: { object: course } }
      end
    end
  end

  def index
    courses = Course.where(user_id: current_user.id).includes(:school).references(:school)
    @current_courses = courses.where("end_date IS ?", nil).or(courses.where("end_date >= ?", Date.today)).order("schools.name").order(:name)
    @past_courses = courses.where("end_date < ?", Date.today).order("schools.name").order(:name)
  end

  def teach
    if session[:group_lesson_id]
      logger.warn("create: group lesson already in progress")
  		redirect_to "/group_lessons/checkout"
      return
  	end
        
    group_lesson = GroupLesson.new
    group_lesson.teacher = current_user

    # Round time to the second to prevent double form submission
    group_lesson.time_in = Time.at((Time.now.to_f).round)

    course = Course.find_by(id: params[:id])
    group_lesson.course = course
    course.students.each do |student|
      lesson = Lesson.new
      lesson.student = student
      lesson.school = course.school
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
    params.require(:course).permit(:id, :name, :notes, :start_date, :end_date, :school_id, student_ids: [])
  end
end
