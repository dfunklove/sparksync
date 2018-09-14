class AdminsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

  def new
  end

  def dashboard
  	@lessons = Lesson.in_progress
  	@teachers = Teacher.waiting_for_students
  end
end
