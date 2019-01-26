module SessionsHelper
  attr_accessor :current_dateview

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
    if logged_in? && current_user.type == 'Teacher'
      @login = Login.where("user_id = ?", session[:user_id]).first
      if @login && !@login.time_out
        @login.update_attributes( time_out: Time.zone.now )
      elsif Rails.env.development?
        raise Exception.new('Teacher time out wasnt null')
      end
    end
    if dv_id = session[:dv_id]
      dv = Dateview.find_by(id: dv_id)
      if dv
        dv.delete
      elsif Rails.env.development?
        raise Exception.new('Junk Dateview ID in session on logout')
      end
      session.delete(:dv_id)
    end
    if session[:sort_col]
      session.delete(:sort_col)
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

  def current_dateview
    d = Dateview.new
    d.start_date = DateTime.parse(session[:dateview_start]) if session[:dateview_start]
    d.end_date = DateTime.parse(session[:dateview_end]) if session[:dateview_end]
    return d
  end

  def set_current_dateview(value)
    session[:dateview_start] = value.start_date
    session[:dateview_end] = value.end_date
  end
end
