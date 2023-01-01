class PartnersController < UsersController
  # filter which of these methods can be used
  # only allow logged in admin to create or update a partner
  before_action :logged_in_user, only: [:index, :create, :update, :delete, :show,
                                        :index]
  before_action :partner_user, only: :school
  before_action :admin_user, only: [:index, :create, :update, :delete]

  def school
    whatschool = '/schools/' + current_user.school_id.to_s
    redirect_to whatschool
  end

  def index
    @partner = Partner.new
    
    prepare_index
  end

  def prepare_index
    @changev = current_visibility
    @partners = visible_records(Partner)
    @delete_warning = "Deleting this partner is irreversible. Are you sure?"
  end

  def handle_error
    prepare_index
    render 'index'
  end
 
  def create
    @partner = Partner.new(partner_params)
    genword = genpassword(@partner)
    @partner.activated = true
    if @partner.save
      # send email
      @partner.send_welcome(@partner.id)
      flash[:info] = "A welcome email was sent to #{@partner.email}"
      redirect_to partners_url
    else
      handle_error
    end
  end

  def update
    partner_id = params[:id]
    @partner = Partner.find(partner_id)
    if params[:modify]
      old_name = "#{@partner.first_name} #{@partner.last_name}"
      if @partner.update(school_id: partner_params[:school_id],
                        first_name: partner_params[:first_name],
                        last_name: partner_params[:last_name],
                        email: partner_params[:email])
        flash[:info] = "#{old_name} was modified."
        redirect_to partners_url
      else
        handle_error
      end
    elsif params[:delete]
      if @partner.activated
        # don't actually delete, set unactivated
        if @partner.update(activated: false)
          flash[:info] = "#{@partner.first_name} #{@partner.last_name} was deactivated."
          redirect_to partners_url
        else
          handle_error
        end
      else
        if @partner.delete
          flash[:info] = "#{@partner.first_name} #{@partner.last_name} was deleted."
          redirect_to partners_url
        else
          handle_error
        end
      end
    elsif params[:activate]
      if @partner.update(activated: true)
        flash[:info] = "#{@partner.first_name} #{@partner.last_name} was activated."
        redirect_to partners_url
      else
        handle_error
      end
    elsif params[:reset]
      genword = genpassword(@partner)
      if @partner.update(password: genword)
        @partner.send_password_reset_email
        flash[:info] = "A password reset email was sent to #{@partner.email}"
        redirect_to partners_url
      else
        handle_error
      end      
    elsif params[:hours]
      redirect_to partner_path(partner_id)
    else
      raise Exception.new('not modify, delete, activate or reset. who called partner update?')
    end
  end

  private
    def partner_params
      params.require(:partner).permit(:first_name, :last_name, :email, :school_id)
    end

    def partner_user
      redirect_to(root_url) unless current_user.partner?
    end
end
