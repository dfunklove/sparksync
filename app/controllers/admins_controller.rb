class AdminsController < ApplicationController
  def new
  end

  def dashboard
  	@lessons = Lesson.in_progress
  	@teachers = Teacher.waiting_for_students
  end
end
