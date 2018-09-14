class Lesson < ApplicationRecord
  DATETIME_FORMAT = "%Y-%m-%d %l:%M %p".freeze 
  TIME_FORMAT = "%l:%M %p".freeze

  belongs_to :student
  belongs_to :teacher, optional: true, class_name: 'Teacher',foreign_key: 'user_id'
  belongs_to :school

  def self.in_progress
  	Lesson.where(time_out: nil).where("time_in > ?", Time.new.beginning_of_day)
  end

end
