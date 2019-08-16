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

    error_message = 'Please finish open lesson before starting a new one'
    open_lesson = current_user.lessons_in_progress.first
    open_group_lesson = current_user.group_lessons_in_progress.first
    if open_group_lesson
      @group_lesson = open_group_lesson
      session[:group_lesson_id] = open_group_lesson.id
      flash.now[:danger] = error_message
      render "checkout"
    elsif open_lesson
      session[:lesson_id] = open_lesson.id
      flash[:danger] = error_message
      redirect_to "/lessons/checkout"
    elsif !@group_lesson
      @group_lesson = GroupLesson.new

      # populate lessons from students
      @students.each do |student|
        lesson = Lesson.new
        lesson.student = student
        @group_lesson.lessons << lesson
      end
    end
  end

  def create
    @confirm_add_student = false
    @group_lesson = GroupLesson.new
    @payload      = GroupLesson.new
    @group_lesson.teacher = @payload.teacher = current_user
    @group_lesson.time_in = @payload.time_in = Time.now
    @selected = []
    i = 0

    # pick only the students/lessons which are selected
    params[:group_lesson][:lessons_attributes].keys.each do |key|
      lesson_data = params[:group_lesson][:lessons_attributes][key]
      selected = lesson_data["selected"]
      @lesson = Lesson.new(lesson_params(lesson_data))
      @lesson.teacher = current_user
      @lesson.time_in = @group_lesson.time_in
      if !@lesson.student_id && (params[:add_student] || params[:new_student])
        begin
          @student = Student.new(student_params lesson_data[:student])
          @lesson.school_id = @student.school_id
          if @student.school_id
            @school = School.find(@student.school_id)
          else
            @school = School.new
          end
        rescue => e
          p e
          @lesson ||= Lesson.new
          @student ||= Student.new
          @school ||= School.new
        end
        @lesson.student = @student
        lookup_student_for_lesson
        selected = @lesson.student.id
      end
      @group_lesson.lessons << @lesson
      if selected
        @selected[i] = true
        @payload.lessons << @lesson
      end        
      i += 1
    end

    puts "payload.lessons.size=#{@payload.lessons.size}, listing="
    p @payload.lessons

    if @payload.lessons.size < 2
      @payload.errors.add(
        :base,
        :add_more_students,
        message: "Please select two or more students"
      )
    end

    respond_to do |format|
      if @confirm_add_student
        format.html { render action: 'new'} # is this tested?
        format.js { render 'confirm_add_student' }
      elsif params[:new_student] || params[:add_student]
        if @lesson.valid?
          format.html { render action: 'new'}
          format.js
        else
          format.html { render action: 'new'}
          format.js { render 'checkout_error', locals: { object: @lesson } }
        end
      elsif @payload.errors.count == 0 && @payload.save
        session[:group_lesson_id] = @payload.id
        format.html { redirect_to "/group_lessons/checkout" }
      else
        format.html { render action: 'new'}
        format.js { render 'checkout_error', locals: { object: @payload } }
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
   	    @lesson.student = @student = @stdnt_lookedup
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
    @group_lesson = GroupLesson.find_by_id(session[:group_lesson_id])
    temp_params = group_lesson_params
    temp_params[:lessons_attributes].keys.each do |key|
      lesson_data = temp_params[:lessons_attributes][key]
      if (lesson_data[:behavior].blank?)
        @group_lesson.errors.add(
          :base,
          :behavior_missing,
          message: "Behavior can't be blank")
      end
      if (lesson_data[:progress].blank?)
        @group_lesson.errors.add(
          :base,
          :progress_missing,
          message: "Progress can't be blank")
      end
      break if @group_lesson.errors.count > 0
    end

    temp_params[:time_out] = Time.now
    @group_lesson.lessons.each do |lesson|
      lesson.time_out = temp_params[:time_out]
    end
    
    respond_to do |format|
      if @group_lesson.errors.count == 0 && @group_lesson.update_attributes(temp_params)
        session.delete(:group_lesson_id)
        format.html { redirect_to '/group_lessons/new' }
      else
        format.html { render action: 'checkout'}
        format.js { render '/shared/error', locals: { object: @group_lesson } }
      end
    end
  end

  def update
  end

  def destroy
  end

  private
    def group_lesson_params
      params.require(:group_lesson).permit(:id, :notes, { lessons_attributes: [:id, :brought_books, :brought_instrument, :student_id, :school_id, :progress, :behavior, :notes]})
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
