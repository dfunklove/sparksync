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

  # Logs out the current user.
  def log_out
    if current_user.type == 'Teacher'
      @login = Login.where("user_id = ?", session[:user_id]).first
      if !@login.time_out
        @login.update_attributes( time_out: Time.zone.now )
      else
        raise Exception.new('Teacher time out wasnt null')
      end
    end
    session.delete(:user_id)
    @current_user = nil
  end
end
