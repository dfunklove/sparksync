class LessonsController < ApplicationController
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

  def create
  	@lesson = Lesson.new(lesson_params)
  	student = Student.find_or_create_by(student_params)
  	school = School.find_or_create_by(school_params)
  	student.school = school
  	@lesson.student = student
  	@lesson.school = school
  	@lesson.teacher = current_user
  	@lesson.timeIn = Time.now
  	if @lesson.save
	  	session[:lesson_id] = @lesson.id
	  	redirect_to "/lessons/checkout"
  	else
  		# TODO: Find a cleaner way to set these values w/o copy-paste
	  	@lesson = Lesson.new
	  	@student = Student.new
	  	@school = School.new
	  	@allSchools = School.all
  		render 'new'
  	end
  end

  def checkout
  	if !session[:lesson_id]
  		redirect_to root_url
  	end
  	@lesson = Lesson.find(session[:lesson_id])
  end

  def finishCheckout
  	if !session[:lesson_id]
  		redirect_to root_url
  	end
  	@lesson = Lesson.find(session[:lesson_id])
  	temp_params = lesson_params
  	temp_params[:timeOut] = Time.now
  	if @lesson.update_attributes(temp_params)
  		session.delete(:lesson_id)
      redirect_to root_url
  	else
      render 'checkout'
  	end
  end

  private 
  def lesson_params
  	params.require(:lesson).permit(:timeIn, :timeOut, :broughtInstrument, :broughtBooks,
  		:progress, :behavior, :notes)
  end

  def student_params
  	params.require(:student).permit(:firstName, :lastName)
  end

  def school_params
  	params.require(:school).permit(:name)
  end
end
