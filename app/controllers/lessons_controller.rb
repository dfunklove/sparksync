class LessonsController < ApplicationController
  before_action :logged_in_user
  before_action :teacher_user, only: [:new, :create, :checkout, :finishCheckout]
  before_action :admin_user, only: :index

  def new
    student_id=params[:s_id]
    if student_id
      # teachers can only select from students they have taught before
      # this prevents users from harvesting student names by putting id's in the url
      allowed_students = Student.find_by_teacher(current_user.id)
      @student = allowed_students.find_by(id: student_id)
      if !@student
        flash.now[:danger] = 'Invalid student id.  Please enter data manually.'
      end
    end
    if @student
      @school = @student.school
      @allSchools = [@school]
    else
      @student = Student.new
      @school = School.new
      @allSchools = School.where(activated: true)
    end
    prepare_new
  end

  def prepare_new
    @students = Student.find_by_teacher(current_user.id)

    error_message = 'Please finish open lesson before starting a new one'
    open_lesson = current_user.lessons_in_progress.first
    open_group_lesson = current_user.group_lessons_in_progress.first
    if open_lesson
      @lesson = open_lesson
      session[:lesson_id] = open_lesson.id
      flash.now[:danger] = error_message
      render "checkout"
    elsif open_group_lesson
      session[:group_lesson_id] = open_group_lesson.id
      flash[:danger] = error_message
      redirect_to "/group_lessons/checkout"
    else
      @lesson ||= Lesson.new
      if !@lesson.student
        @lesson.student = Student.new
      end
    end
  end

  def index
    school_id = params[:id]

    prepare_index
  end

  def prepare_index
    @dateview = current_dateview

    # title and what column depend on user and in the case
    # of admin, what view she wants
    # nobody but admin and a particular partner has any business
    # doing a school/show
    # can you do the sorting after the db fetch? it would
    # be preferable in order to sort on multiple columns

    @showstudent = true
    @showschool = true
    @showteacher = true
    @showhours = true

    @delete_warning = "Deleting this lesson record is irreversible. Are you sure?"
    @messons = Lesson.find_by_date(@dateview.start_date, @dateview.end_date)
    @messons = Lesson.sort(@messons, session[:sortcol])
    @tot_hours = Teacher.compute_hours(@messons)
    respond_to do |format|
      format.html
      format.xls 
    end
  end

  def handle_index_error
    prepare_index
    render 'index'
  end

  def muckwithdate(whatdate)
    turn2date = DateTime.strptime(whatdate, '%l:%M %p %m-%d-%Y')
    screwyrailstime = turn2date.strftime('%l:%M %p %Y-%m-%d')
    intimezoneDST = screwyrailstime.in_time_zone('Central Time (US & Canada)')
  end

  def update
    @lesson = Lesson.find(params[:id])
    if params[:modify]
      begin
        time_in_obj = muckwithdate(messon_params[:time_in])
        time_out_obj = muckwithdate(messon_params[:time_out]) 
      rescue => e
        @lesson.errors.add(
            :base,
            :invalid_date,
            message: "Invalid date")
      end
      if @lesson.errors.count == 0 && @lesson.update(
          # TODO these are assuming the time in params is GMT and converting to local fixit 
          time_in: time_in_obj,
          time_out: time_out_obj,
          brought_instrument: messon_params[:brought_instrument],
          brought_books: messon_params[:brought_books],
          progress: messon_params[:progress],
          behavior: messon_params[:behavior],
          notes: messon_params[:notes])
        redirect_to lessons_path
      else 
        handle_index_error
      end
    elsif params[:delete]
      if @lesson.delete
        redirect_to lessons_path
      else
        handle_index_error
      end
    else
      raise Exception.new('not modify or delete. who called lesson update?')
    end 
  end

  def create
    add_student_confirmed = params[:add_student_confirmed]
    lesson = Lesson.new(lesson_params)
    lesson.time_in = Time.now
    lesson.teacher = current_user

    confirm_add_student = false
    if !lesson.student_id
      begin
        student = Student.new(student_params)
        student.school = School.find_by(id: student.school_id) || School.new
      rescue => e
        p e
        student = Student.new
        student.school ||= school.new
      end
      lesson.student = student
      lesson.school_id = student.school_id

      confirm_add_student = lookup_student_for_lesson lesson, add_student_confirmed
    end

    # check errors count first or custom errors get cleared
    respond_to do |format|
      if confirm_add_student
        format.js { render 'confirm_add_student' }
      elsif lesson.errors.count == 0 && lesson.save
        session[:lesson_id] = lesson.id
        format.html { redirect_to "/lessons/checkout" }
      else
        format.js { render '/shared/error', locals: { object: lesson } }
      end
    end
end

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
    if (temp_params[:behavior] == nil)
      @lesson.errors.add(
        :base,
        :behavior_missing,
        message: "Behavior can't be blank")
    end
    if (temp_params[:progress] == nil)
      @lesson.errors.add(
        :base,
        :progress_missing,
        message: "Progress can't be blank")
    end

    temp_params[:time_out] = Time.now

    respond_to do |format|
      if @lesson.errors.count == 0 && @lesson.update_attributes(temp_params)
        session.delete(:lesson_id)
        format.html { redirect_to '/lessons/new' }
      else
        format.html { render action: 'checkout' }
        format.js { render '/shared/error', locals: { object: @lesson } }
      end
    end
  end

  def sort
    # TODO how do you toggle between asc and desc?
    session[:sortcol] = params[:sortcol]
    # puts "sortcol " + session[:sortcol]
    # redirecting, you execute the entire action from start
    redirect_to request.referrer
  end

  private 
  def lesson_params
  	params.require(:lesson).permit(:time_in, :time_out, :brought_instrument, :brought_books,
      :progress, :behavior, :notes, :school_id, :student_id
      #student_attributes: [:id, :first_name, :last_name, :school_id]
      )
  end

  def messon_params
  	params.require(:lesson).permit(:time_in, :time_out, :brought_instrument, :brought_books,
  		:progress, :behavior, :notes, :user_id, :school_id, :student_id)
  end

  def student_params
  	params.require(:lesson).require(:student).permit(:first_name, :last_name, :school_id)
  end

  def school_params
  	params.require(:school).permit(:name)
  end

  def dateview_params
    params.require(:dateview).permit(:start_date, :end_date)
  end

  def teacher_user
    return if current_user.teacher?
    redirect_to(root_url) 
  end
end
