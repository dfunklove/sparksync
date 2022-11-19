class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_url
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    if current_user.teacher? && handle_open_lesson
      return
    end
    log_out
    redirect_to root_url
  end

  def change_view
    changev = params[:changev]
    if changev == "Active"
      session[:changev] = "All"
    elsif changev == "All"
      session[:changev] = "Inactive"
    else
      session[:changev] = "Active"
    end
    redirect_to request.referrer
  end
end
