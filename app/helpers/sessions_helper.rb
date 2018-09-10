module SessionsHelper
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
    if user.type == 'Teacher'
      @login = Login.new( user_id: user.id, time_in: Time.zone.now )
      @login.save!
    end
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    if current_user.type == 'Teacher'
      @login = Login.where("user_id = ?", session[:user_id]).first
      if @login && !@login.time_out
        @login.update_attributes( time_out: Time.zone.now )
      else
        raise Exception.new('Teacher time out wasnt null')
      end
    end
    if dv_id = session[:dv_id]
      Dateview.find(dv_id).delete
      session.delete(:dv_id)
    end
    if session[:changev]
      session.delete(:changev)
    end
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end
