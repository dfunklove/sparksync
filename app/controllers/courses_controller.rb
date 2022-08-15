class CoursesController < ApplicationController
  before_action :logged_in_user
  before_action :teacher_user

  def new
    @course = Course.new
  end

  def index
    @courses = Course.where(user_id: current_user.id)
  end

  def teacher_user
    return if current_user.teacher?
    redirect_to(root_url) 
  end  
end
