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

  def new_single
    prepare_new
  end

  def new_group
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

  def index
    store_location
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

    @schools = School.where("activated=?", true).order(:name).collect{|c| [c.name, c.id]}
    @teachers = Teacher.where("activated=?", true).order(:last_name).collect{|t| ["#{t.first_name} #{t.last_name}", t.id]}
    @students = Student.where("activated=?", true).order(:last_name).collect{|s| ["#{s.first_name} #{s.last_name}", s.id]}
    @delete_warning = "Deleting this lesson record is irreversible. Are you sure?"
    @messons = Lesson.find_by_date(@dateview.start_date, @dateview.end_date)
    if session[:sortcol]
      sortcol = session[:sortcol]
      # case by case as sorting by student' slast name or school name is not
      # straightforward
      # puts "final sortcol " + sortcol
      if sortcol == "Student"
        @messons = @messons.sort_by(&:student_last)
      elsif sortcol == "Date" || sortcol == "Time In"
      @messons = @messons.sort_by(&:time_in).reverse! 
      elsif sortcol == "School"
        @messons = @messons.sort_by(&:name)
      elsif sortcol == "Teacher"
        @messons = @messons.sort_by(&:teacher_last)
      elsif sortcol == "Progress"
        @messons = @messons.sort_by(&:progress)
      elsif sortcol == "Behavior"
        @messons = @messons.sort_by(&:behavior)
      end
    else
      @messons = @messons.sort_by(&:time_in).reverse! 
    end
    @tot_hours = 0
    @messons.each do |lesson|
      @tot_hours += lesson[:time_out] - lesson[:time_in]
      # puts "school " + lesson.name
    end
    # convert seconds to hours
    @tot_hours = @tot_hours/3600
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
    # puts "in update"
    lesson_id = params[:id]
    @lesson = Lesson.find(lesson_id)
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
      lesson_id = params[:id]
      what_lesson = Lesson.find(lesson_id)
      if what_lesson.delete
        redirect_to lessons_path
      else
        handle_index_error
      end
    else
      raise Exception.new('not modify or delete. who called lesson update?')
    end 
  end

  def create
    begin
      @lesson = Lesson.new(lesson_params)
      @student = Student.new(student_params)
      @school = School.find(@student.school_id)
    rescue
      @lesson ||= Lesson.new
      @student ||= Student.new
      @school ||= School.new
    end

    if @school.valid? && !@student.first_name.empty? && !@student.last_name.empty?
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

      elsif params[:new_student]
        @student.school = @school
        @student.activated = true
        @student.save
        @lesson.student = @student
        flash[:info] = "Created new student #{@student.first_name} #{@student.last_name} at #{@student.school.name}" 
      else
        @lesson.errors.add(
          :base,
          :not_found_in_database,
          message: 'No student by that name at that school. Check "new student" if you wish to add a new student to database, otherwise correct spelling or school')

      end
      @lesson.school = @school
    end

    @lesson.teacher = current_user
    @lesson.time_in = Time.now

    # check errors count first or custom errors get cleared
  	if @lesson.errors.count == 0 && @lesson.save
	  	session[:lesson_id] = @lesson.id
	  	redirect_to "/lessons/checkout"
  	else
      prepare_new
  		render 'new_single'
  	end
  end

  # leaving checkin page, going to checkout page
  def checkout
  	if !session[:lesson_id]
  		redirect_to root_url
  	end
  	@lesson = Lesson.find(session[:lesson_id])
  end

  def checkout_group
    @lesson = Lesson.new
    @students = Student.find_by_teacher(current_user.id)
    @lesson.student = Student.new
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
  	if @lesson.errors.count == 0 && @lesson.update_attributes(temp_params)
  		session.delete(:lesson_id)
      redirect_to root_url
  	else
      render 'checkout'
  	end
  end

  def sort
    # TODO how do you toggle between asc and desc?
    session[:sortcol] = params[:sortcol]
    # puts "sortcol " + session[:sortcol]
    # redirecting, you execute the entire action from start
    redirect_to session[:forwarding_url]
  end

  private 
  def lesson_params
  	params.require(:lesson).permit(:time_in, :time_out, :brought_instrument, :brought_books,
  		:progress, :behavior, :notes, :school_id, :student_id)
  end

  def messon_params
  	params.require(:lesson).permit(:time_in, :time_out, :brought_instrument, :brought_books,
  		:progress, :behavior, :notes, :user_id, :school_id, :student_id)
  end

  def student_params
  	params.require(:student).permit(:first_name, :last_name, :school_id)
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
