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
        logger.error('Teacher time out wasnt null')
      end
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

  # Destroy the dateview after reading.  This gives it the life cycle of a request parameter.
  def current_dateview
    d = Dateview.new
    d.start_date = DateTime.parse(session[:dateview_start]) if session[:dateview_start]
    d.end_date = DateTime.parse(session[:dateview_end]) if session[:dateview_end]
    session.delete(:dateview_start)
    session.delete(:dateview_end)
    return d
  end

  def set_current_dateview(value)
    session[:dateview_start] = value.start_date
    session[:dateview_end] = value.end_date
  end

  def current_visibility
    return session[:changev] || "Active"
  end

  def visible_records(model)
    vis = current_visibility
    if vis == "Active"
      model.where(activated: true)
    elsif vis == "Inactive"
      model.where(activated: false)
    else
      model.all
    end
  end
end
