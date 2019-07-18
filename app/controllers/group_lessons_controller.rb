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
    @confirm_add_student = false
    @group_lesson = GroupLesson.new(group_lesson_params)
    @group_lesson.teacher = current_user
    @group_lesson.time_in = Time.now
    @selected = []

    # pick only the students/lessons which are selected
    params[:group_lesson][:lessons_attributes].keys.each do |key|
      lesson_data = params[:group_lesson][:lessons_attributes][key]
      if lesson_data["selected"]
        @selected[key] = true
        lesson = Lesson.new(lesson_params(lesson_data))
        lesson.teacher = current_user
        lesson.time_in = @group_lesson.time_in
        if !lesson.student_id
          begin
            @lesson = lesson
            @student = Student.new(student_params lesson_data[:student])
            @lesson.school_id = @student.school_id
            @school = School.find(@student.school_id)
          rescue => e
            p e
            @lesson ||= Lesson.new
            @student ||= Student.new
            @school ||= School.new
          end
          @lesson.student = @student
          lookup_student_for_lesson
        end
        @group_lesson.lessons << lesson
      end
    end

    puts "group_lesson.lessons.size=#{@group_lesson.lessons.size}, listing="
    p @group_lesson.lessons

    respond_to do |format|
      if params[:new_student]
        lesson = Lesson.new
        lesson.student = Student.new
        lesson.student.school = School.new
        @group_lesson.lessons << lesson
        format.html { render action: 'new'}
      elsif @group_lesson.errors.count == 0 && @group_lesson.save
        session[:group_lesson_id] = @group_lesson.id
        format.html { redirect_to "/group_lessons/checkout" }
      elsif @confirm_add_student
        format.html { render action: 'new'} # is this tested?
        format.js { render 'confirm_add_student' }
      else
        format.html { render action: 'new'}
        format.js # implied: render 'create'
      end
    end
  end

  def lookup_student_for_lesson
    if @school.valid? && !@student.first_name.empty? && !@student.last_name.empty?
      # if student exists in db get all the column values
      # if student not in db prompt user to see if they want to create
      harrys = Student.find_by_name(@student.first_name, @student.last_name, @school.id)
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
        @confirm_add_student = true
      end
      @lesson.school = @school
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
      params.permit(:first_name, :last_name, :school_id)
    end

    def teacher_user
      return if current_user.teacher?
      redirect_to(root_url) 
    end  
  end
