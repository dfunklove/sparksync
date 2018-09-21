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
    # create a School object based on keyboard input
    @school = School.new(school_params)
    # see if the school exists in the database, if not raise exception
    # if school does exist in db, get all the column values
    # params[:school][:name] = 'Murchison'
    if !@school = School.find_by(school_params)
      raise
    end

    #create a student object given the parameters entered
    @student = Student.new(student_params)
    # if student exists in db get all the column values
    # if student not in db prompt user to see if they want to create
    harrys = Student.where('"last_name" ilike ?', @student.last_name + "%").where('"first_name" ilike ?', @student.first_name + "%").where( school_id: @school.id)
    @stdnt_lookedup = harrys.first
    nharrys = harrys.count

    if @stdnt_lookedup
 	    @lesson.student = @stdnt_lookedup
      puts "number of students " + nharrys.to_s
      if nharrys > 1
        @lesson.errors.add(
          :base,
          :first_name_or_last_name_ambiguous,
          message: "Need to spell out entire name")
      end
    else
      @lesson.errors.add(
        :base,
        :not_found_in_database,
        message: 'No student by that name at that school. Check "new student" if you wish to add a new student to database, otherwise correct spelling or school')
    end
  	@lesson.school = @school
  	@lesson.teacher = current_user
  	@lesson.time_in = Time.now

    # check errors count first or custom errors get cleared
  	if @lesson.errors.count == 0 && @lesson.save
	  	session[:lesson_id] = @lesson.id
	  	redirect_to "/lessons/checkout"
  	else
	  	@allSchools = School.all
  		render 'new'
  	end
  end

  # leaving checkin page, going to checkout page
  def checkout
  	if !session[:lesson_id]
  		redirect_to root_url
  	end
  	@lesson = Lesson.find(session[:lesson_id])
  end

  # leaving checkout page, returning to checkin page
  def finishCheckout
  	if !session[:lesson_id]
  		redirect_to root_url
  	end
  	@lesson = Lesson.find(session[:lesson_id])
  	temp_params = lesson_params
  	temp_params[:time_out] = Time.now
  	if @lesson.update_attributes(temp_params)
  		session.delete(:lesson_id)
      redirect_to root_url
  	else
      render 'checkout'
  	end
  end

  def sort
    # TODO how do you toggle between asc and desc?
    session[:sortcol] = params[:sortcol]
    # redirecting, you execute the entire action from start
    redirect_to session[:forwarding_url]
  end

  private 
  def lesson_params
  	params.require(:lesson).permit(:time_in, :time_out, :brought_instrument, :brought_books,
  		:progress, :behavior, :notes)
  end

  def student_params
  	params.require(:student).permit(:first_name, :last_name)
  end

  def school_params
  	params.require(:school).permit(:name)
  end
end
