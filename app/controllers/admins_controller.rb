class AdminsController < UsersController
  before_action :logged_in_user
  before_action :admin_user

  def index
    @admin = Admin.new

    prepare_index    
  end

  def prepare_index
    @changev = current_visibility
    @admins = visible_records(Admin)
    @delete_warning = "Deleting this admin is irreversible. Are you sure?"
  end

  def handle_error
    prepare_index
    render 'index'
  end

  def create
    @admin = Admin.new(admin_params)
    genword = genpassword(@admin)
    @admin.activated = true
    if @admin.save
      # send email
      @admin.send_welcome(@admin.id)
      #flash[:info] = "A welcome email was sent to #{@admin.email}"
      redirect_to admins_url
    else
      handle_error
    end
  end

  def update
    admin_id = params[:id]
    @admin = Admin.find(admin_id)
    if params[:modify]
      puts "modify"
      if @admin.update(school_id: admin_params[:school_id],
                        first_name: admin_params[:first_name],
                        last_name: admin_params[:last_name],
                        email: admin_params[:email])
        #flash[:info] = "#{@admin.first_name} #{@admin.last_name} was modified."
        redirect_to admins_url
      else
        handle_error
      end
    elsif params[:delete]
      puts "delete"
      if @admin.activated
        # don't actually delete, set unactivated
        if @admin.update(activated: false)
          #flash[:info] = "#{@admin.first_name} #{@admin.last_name} was deactivated."
          redirect_to admins_url
        else
          handle_error
        end
      else
        if @admin.delete
          #flash[:info] = "#{@admin.first_name} #{@admin.last_name} was deleted."
          redirect_to admins_url
        else
          handle_error
        end
      end
    elsif params[:activate]
      puts "activate"
      if @admin.update(activated: true)
        #flash[:info] = "#{@admin.first_name} #{@admin.last_name} was activated."
        redirect_to admins_url
      else
        handle_error
      end
    elsif params[:reset]
      puts "reset"
      genword = genpassword(@admin)
      if @admin.update(password: genword)
        @admin.send_password_reset_email
        redirect_to admins_url
      else
        handle_error
      end      
    elsif params[:hours]
      redirect_to admin_path(admin_id)
    else
      raise Exception.new('not modify, delete, activate, or reset. who called admin update?')
    end
  end

  def dashboard
  	@lessons = Lesson.in_progress
  	@teachers = Teacher.waiting_for_students
  end

  private
    def admin_params
      params.require(:admin).permit(:first_name, :last_name, :email, :school_id)
    end
end
