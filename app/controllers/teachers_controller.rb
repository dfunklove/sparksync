class TeachersController < ApplicationController

  # new refers to one of the actions generated
  # by resources :teachers in config/routes.rb
  def new
    # @teachers and @teacher are variable provided
    # to the new.html.erb view
    @teachers = Teacher.all
    @teacher = Teacher.new
  end
end
