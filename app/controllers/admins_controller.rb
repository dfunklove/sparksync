class AdminsController < UsersController
  before_action :logged_in_user
  before_action :admin_user

  def new
    store_location
    
    if session[:changev]
      @changev = session[:changev] 
    else 
      @changev = "Active"
    end

    @admins = find_right_admins
    @admin = Admin.new
    @delete_warning = "Deleting this admin is irreversible. Are you sure?"
  end

  def find_right_admins
    if @changev == "Active"
      Admin.where(activated: true)
    elsif @changev == "Inactive"
      Admin.where(activated: false)
    else
      Admin.all
    end
  end
 
  def create
    @admin = Admin.new(admin_params)
    genword = genpassword(@admin)
    @admin.activated = true
    if @admin.save
      # send email
      @admin.send_welcome(@admin.id)
      redirect_to new_admin_path
    else
      @admins = find_right_admins
      if session[:changev]
        @changev = session[:changev]
      else
        @changev = "Active"
      end
      render 'new'
    end
  end

  def update
    admin_id = params[:id]
    @admin = Admin.find(admin_id)
    if params[:modify]
      puts "modify"
      # won't work without password
      genword = genpassword(@admin)
      if Admin.update(@admin.id,
                        school_id: admin_params[:school_id],
                        first_name: admin_params[:first_name],
                        last_name: admin_params[:last_name],
                        email: admin_params[:email],
                        activated: true,
                        password: genword)
        # send email
      	@admin.send_password_reset_email
        redirect_to new_admin_path
      else
        @admins = find_right_admins
        if session[:changev]
          @changev = session[:changev]
        else
          @changev = "Active"
        end
        render 'new'
      end
    elsif params[:delete]
      puts "delete"
      admin_id = @admin.id 
      who = Admin.find(admin_id)
      if who.activated
        genword = genpassword(who)
        # don't actually delete, set unactivated
        if who.update( activated: false,
                       password: genword)
          redirect_to new_admin_path
        else
          @admins = find_right_admins
          if session[:changev]
            @changev = session[:changev]
          else
            @changev = "Active"
          end
          render 'new'
        end
      else
        if who.delete
          redirect_to new_admin_path
        else
          @admins = find_right_admins
          if session[:changev]
            @changev = session[:changev]
          else
            @changev = "Active"
          end
          render 'new'
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
