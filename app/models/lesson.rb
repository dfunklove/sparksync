class Lesson < ApplicationRecord
  DATETIME_FORMAT = "%Y-%m-%d %l:%M %p".freeze 
  TIME_FORMAT = "%l:%M %p".freeze

  belongs_to :student
  belongs_to :teacher, optional: true, class_name: 'Teacher',foreign_key: 'user_id'
  belongs_to :school

  def self.in_progress
  	self.joins(:student).where("lessons.time_out is null AND lessons.time_in > ?", Time.new.beginning_of_day).order("students.school_id")
  end

end
