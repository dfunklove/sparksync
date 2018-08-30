module SessionsHelper
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
    @login = Login.new( user_id: user.id, time_in: Time.zone.now )
    @login.save
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    @login = Login.where("user_id = ?", session[:user_id]).first
    session.delete(:user_id)
    if @login && !@login.time_out
      @login.update_attributes( time_out: Time.zone.now )
    else
      puts "time out wasn't null"
    end
    @current_user = nil
  end
end
