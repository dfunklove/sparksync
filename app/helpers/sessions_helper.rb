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

  def handle_open_lesson
    error_message = 'Please finish open lesson first!'
    open_lesson = current_user.lessons_in_progress.first
    open_group_lesson = current_user.group_lessons_in_progress.first
    if open_lesson
      session[:lesson_id] = open_lesson.id
      flash[:danger] = error_message
      redirect_to "/lessons/checkout"
      return true
    elsif open_group_lesson
      session[:group_lesson_id] = open_group_lesson.id
      flash[:danger] = error_message
      redirect_to "/group_lessons/checkout"
      return true
    else
      return false
    end
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
