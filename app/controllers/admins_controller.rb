class AdminsController < ApplicationController
  def new
  end

  def dashboard
  	@lessons = Lesson.in_progress
  end
end
