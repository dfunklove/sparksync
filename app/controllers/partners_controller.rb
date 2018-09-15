class PartnersController < UsersController
  # filter which of these methods can be used
  # only allow logged in admin to create or update a partner
  before_action :logged_in_user, only: [:new, :create, :update, :delete, :show,
                                        :index]
  before_action :partner_user, only: :index
  before_action :admin_user, only: [:new, :create, :update, :delete]

  def index
    whatschool = '/schools/' + current_user.school_id.to_s
    redirect_to whatschool
  end

  # new refers to one of the actions generated
  # by resources :partners in config/routes.rb
  def new
    store_location
    
    if session[:changev]
      @changev = session[:changev] 
    else 
      @changev = "Active"
    end

    # @partners and @partner are variables provided
    # to the new.html.erb view
    @partners = find_right_partners
    @partner = Partner.new
  end

  def find_right_partners
    if @changev == "Active"
      Partner.where(activated: true)
    elsif @changev == "Inactive"
      Partner.where(activated: false)
    else
      Partner.all
    end
  end
 
  def create
    @partner = Partner.new(partner_params)
    genword = genpassword(@partner)
    @partner.activated = true
    if @partner.save
      #TODO send email
      redirect_to new_partner_path
    else
      @partners = find_right_partners
      render 'new'
    end
  end

  def update
    partner_id = params[:id]
    @partner = Partner.find(partner_id)
    if params[:modify]
      puts "modify"
      # won't work without password
      genword = genpassword(@partner)
      if Partner.update(@partner.id,
                        school_id: partner_params[:school_id],
                        first_name: partner_params[:first_name],
                        last_name: partner_params[:last_name],
                        email: partner_params[:email],
                        activated: true,
                        password: genword)
        #TODO send email
        redirect_to new_partner_path
      else
        @partners = find_right_partners
        render 'new'
      end
    elsif params[:delete]
      puts "delete"
      partner_id = @partner.id 
      who = Partner.find(partner_id)
      if who.activated
        genword = genpassword(who)
        # don't actually delete, set unactivated
        if who.update( activated: false,
                       password: genword)
          redirect_to new_partner_path
        else
          @partners = find_right_partners
          render 'new'
        end
      else
        if who.delete
          redirect_to new_partner_path
        else
          @partners = find_right_partners
          render 'new'
        end
      end
    elsif params[:hours]
      redirect_to partner_path(partner_id)
    else
      raise Exception.new('not welcome, modify or delete. who called partner update?')
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
