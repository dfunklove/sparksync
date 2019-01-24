class SchoolsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :update, :delete, :show]
  before_action :admin_user, only: [:new, :create, :update, :delete]
  before_action :correct_user, only: :show

  def show
    store_location
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
    end
    # convert seconds to hours
    @tot_hours = @tot_hours/3600
    respond_to do |format|
      format.html
      format.xls
    end

  end

  # new refers to one of the actions generated
  # by resources :schools in config/routes.rb
  def new
    store_location
    
    if session[:changev]
      @changev = session[:changev] 
    else 
      @changev = "Active"
    end

    # @schools and @school are variables provided
    # to the new.html.erb view
    @schools = find_right_schools
    @school = School.new
    @delete_warning = "Deleting this school is irreversible. Are you sure?"
  end

  def find_right_schools
    if @changev == "Active"
      School.where(activated: true)
    elsif @changev == "Inactive"
      School.where(activated: false)
    else
      School.all
    end
  end

  def create
    @school = School.new(school_params)
    @school.activated = true
    if @school.save
      redirect_to new_school_path
    else
      if session[:changev]
        @changev = session[:changev] 
      else 
        @changev = "Active"
      end

      @schools = find_right_schools
      render 'new'
    end
  end

  def update
    school_id = params[:id]
    @school = School.find(school_id)
    if params[:modify]
      puts "modify"
      if School.update(@school.id,
                        name: school_params[:name],
                        activated: true)
        redirect_to new_school_path
      else
        @schools = find_right_schools
        render 'new'
      end
    elsif params[:delete]
      puts "delete"
      school_id = @school.id 
      who = School.find(school_id)
      if who.activated
        # don't actually delete, set unactivated
        if who.update(activated: false)
          redirect_to new_school_path
        else
          @schools = find_right_schools
          render 'new'
        end
      else
        if who.delete
          redirect_to new_school_path
        else
          @schools = find_right_schools
          render 'new'
        end
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
