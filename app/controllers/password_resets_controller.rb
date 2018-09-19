class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    # there is no params[:user], there is a params[:admin] a params [:teacher]
    # or a params[:partner]
    if params[:admin]
      if params[:admin][:password].empty?                  # Case (3)
        @user.errors.add(:password, "can't be empty")
        render 'edit'
      elsif @user.update_attributes(admin_params)          # Case (4)
        log_in @user
        @user.update_attribute(:reset_digest, nil)
        flash[:success] = "Password has been reset."
        redirect_to root_url
      else
        render 'edit'                                     # Case (2)
      end
    elsif params[:teacher]
      if params[:teacher][:password].empty?                  # Case (3)
        @user.errors.add(:password, "can't be empty")
        render 'edit'
      elsif @user.update_attributes(teacher_params)          # Case (4)
        log_in @user
        @user.update_attribute(:reset_digest, nil)
        flash[:success] = "Password has been reset."
        redirect_to root_url
      else
        render 'edit'                                     # Case (2)
      end
    elsif params[:partner]
      if params[:partner][:password].empty?                  # Case (3)
        @user.errors.add(:password, "can't be empty")
        render 'edit'
      elsif @user.update_attributes(partner_params)          # Case (4)
        log_in @user
        @user.update_attribute(:reset_digest, nil)
        flash[:success] = "Password has been reset."
        redirect_to root_url
      else
        render 'edit'                                     # Case (2)
      end
    else
        @user.errors.add(:base, "unknown user type")
        render 'edit'
    end
  end
  private

    def admin_params
      params.require(:admin).permit(:password, :password_confirmation)
    end

    def teacher_params
      params.require(:teacher).permit(:password, :password_confirmation)
    end

    def partner_params
      params.require(:partner).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
