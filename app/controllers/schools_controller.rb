class SchoolsController < ApplicationController
  before_action :logged_in_user, only: [:index, :create, :update, :delete, :show]
  before_action :admin_user, only: [:index, :create, :update, :delete]
  before_action :correct_user, only: :show

  def show
    school_id = params[:id]

    @school = School.find(school_id)
    @dateview = current_dateview

    # title and what column depend on user and in the case
    # of admin, what view she wants
    # nobody but admin and a particular partner has any business
    # doing a school/show
    # can you do the sorting after the db fetch? it would
    # be preferable in order to sort on multiple columns

    @showstudent = true
    @showschool = false
    @showteacher = true
    @showhours = true

    @lessons = Lesson.find_by_school(school_id, @dateview.start_date, @dateview.end_date)
    if session[:sortcol]
      sortcol = session[:sortcol]
      # case by case as sorting by student' slast name or school name is not
      # straightforward
      if sortcol == "Student"
        @lessons = @lessons.sort_by(&:student_last)
      elsif sortcol == "Date"
        @lessons = @lessons.sort_by(&:time_in).reverse! 
      elsif sortcol == "Teacher"
        @lessons = @lessons.sort_by(&:teacher_last)
      elsif sortcol == "Progress"
        @lessons = @lessons.sort_by(&:progress)
      elsif sortcol == "Behavior"
        @lessons = @lessons.sort_by(&:behavior)
      end
    else
      @lessons = @lessons.sort_by(&:time_in).reverse! 
    end
    @tot_hours = 0
    @lessons.each do |lesson|
      @tot_hours += lesson[:time_out] - lesson[:time_in]
      LessonsHelper::add_empty_ratings(lesson)
    end
    # convert seconds to hours
    @tot_hours = @tot_hours/3600
    respond_to do |format|
      format.html
      format.xls
    end

  end

  def index
    @school = School.new

    prepare_index    
  end

  def prepare_index
    @changev = current_visibility
    @schools = visible_records(School)
    @delete_warning = "Deleting this school is irreversible. Are you sure?"
  end

  def handle_error
    prepare_index
    render 'index'
  end

  def create
    @school = School.new(school_params)
    @school.activated = true
    if @school.save
      redirect_to schools_url
    else
      handle_error
    end
  end

  def update
    school_id = params[:id]
    @school = School.find(school_id)
    if params[:modify]
      puts "modify"
      if @school.update(name: school_params[:name])
        redirect_to schools_url
      else
        handle_error
      end
    elsif params[:delete]
      puts "delete"
      if @school.activated
        # don't actually delete, set unactivated
        if @school.update(activated: false)
          flash[:info] = "#{@school.name} and all of its students have been deactivated"
          redirect_to schools_url
        else
          handle_error
        end
      else
        begin
          # should throw exception on error
          @school.delete!
          redirect_to schools_url
        rescue
          @school.errors.add(
            :base,
            :school_has_students,
            message: "Unable to delete because this school has students assigned to it")
          handle_error
        end
      end
    elsif params[:activate]
      puts "activate"
      if @school.update(activated: true)
        flash[:info] = "#{@school.name} and all of its students have been activated"
        redirect_to schools_url
      else
        handle_error
      end
    elsif params[:hours]
      redirect_to school_path(school_id)
    else
      raise Exception.new('not welcome, modify or delete. who called school update?')
    end
  end

  private
    def school_params
      params.require(:school).permit(:name)
    end
    def dateview_params
      params.require(:dateview).permit(:start_date, :end_date)
    end
    # Confirms the correct user.
    def correct_user
      return if current_user.type == "Admin"
      @school = School.find(params[:id])
      return if current_user.type == "Partner" && current_user.school_id == @school.id
      redirect_to(root_url)
    end
end
