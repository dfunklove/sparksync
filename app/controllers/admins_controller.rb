class AdminsController < UsersController
  before_action :logged_in_user
  before_action :admin_user

  def index
    store_location
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
      # won't work without password
      genword = genpassword(@admin)
      if @admin.update(school_id: admin_params[:school_id],
                        first_name: admin_params[:first_name],
                        last_name: admin_params[:last_name],
                        email: admin_params[:email],
                        activated: true,
                        password: genword)
        # send email
      	@admin.send_password_reset_email
        redirect_to admins_url
      else
        handle_error
      end
    elsif params[:delete]
      puts "delete"
      if @admin.activated
        genword = genpassword(@admin)
        # don't actually delete, set unactivated
        if @admin.update( activated: false,
                       password: genword)
          redirect_to admins_url
        else
          handle_error
        end
      else
        if @admin.delete
          redirect_to admins_url
        else
          handle_error
        end
      end
    elsif params[:hours]
      redirect_to admin_path(admin_id)
    else
      raise Exception.new('not welcome, modify or delete. who called admin update?')
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
