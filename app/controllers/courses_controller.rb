class CoursesController < ApplicationController
  before_action :logged_in_user

  def new
    @title = "New Session"
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
      name = "#{course.name} (#{i})"
      break if not names.include? name
      i += 1
    end
    attrs['name'] = name

    new_course = Course.new(attrs)
    new_course.students = course.students
    respond_to do |format|
      if new_course.save
        format.html { redirect_to "/courses" }
      else
        format.js { render '/shared/error', locals: { object: course } }
      end
    end
  end

  def create
    course = Course.new(course_params)
    if !params[:course][:student_ids] || params[:course][:student_ids].length < 2
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
    @title = "Edit Session"
    @course = Course.find_by(id: params[:id])
  end

  def update
    course = Course.find_by(id: params[:id])
    if !params[:course][:student_ids] || params[:course][:student_ids].length < 2
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
    courses = nil
    if current_user.admin?
      courses = Course.all.includes(:school, :teacher).references(:school, :teacher)
    else
      courses = Course.where(user_id: current_user.id).includes(:school).references(:school)
    end
    @current_courses = courses.where("end_date IS ?", nil).or(courses.where("end_date >= ?", Date.today)).order("schools.name").order(:name)
    @past_courses = courses.where("end_date < ?", Date.today).order("schools.name").order(:name)
  end

  def teach
    if handle_open_lesson
      return
    end
        
    @group_lesson = GroupLesson.new
    @group_lesson.teacher = current_user

    course = Course.find_by(id: params[:id])
    @group_lesson.course = course
    course.students.each do |student|
      lesson = Lesson.new
      lesson.student = student
      lesson.school = course.school
      @group_lesson.lessons << lesson
    end

    render "/group_lessons/new"
  end

  def teacher_user
    return if current_user.teacher?
    redirect_to(root_url) 
  end  

  def course_params
    params.require(:course).permit(:id, :name, :notes, :start_date, :end_date, :school_id, :user_id, student_ids: [])
  end
end
