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
    store_location
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
      redirect_to partners_url
    else
      handle_error
    end
  end

  def update
    partner_id = params[:id]
    @partner = Partner.find(partner_id)
    if params[:modify]
      puts "modify"
      if @partner.update(school_id: partner_params[:school_id],
                        first_name: partner_params[:first_name],
                        last_name: partner_params[:last_name],
                        email: partner_params[:email],
                        activated: true)
        redirect_to partners_url
      else
        handle_error
      end
    elsif params[:delete]
      puts "delete"
      if @partner.activated
        # don't actually delete, set unactivated
        if @partner.update(activated: false)
          redirect_to partners_url
        else
          handle_error
        end
      else
        if @partner.delete
          redirect_to partners_url
        else
          handle_error
        end
      end
    elsif params[:reset]
      puts "reset"
      genword = genpassword(@partner)
      if @partner.update(password: genword)
        @partner.send_password_reset_email
        redirect_to partners_url
      else
        handle_error
      end      
    elsif params[:hours]
      redirect_to partner_path(partner_id)
    else
      raise Exception.new('not modify, delete, or reset. who called partner update?')
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
