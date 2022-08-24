class GroupLesson < ApplicationRecord
  has_many :lessons, dependent: :destroy
  belongs_to :teacher, class_name: 'Teacher',foreign_key: 'user_id'

  validates :teacher, presence: true
  validates :time_in, uniqueness: { scope: :user_id }
  validates_associated :lessons

  accepts_nested_attributes_for :lessons

  before_validation :set_lesson_fields

  def set_lesson_fields
    self.lessons.each do |lesson|
      lesson.teacher = self.teacher
      lesson.time_in = self.time_in
      lesson.time_out = self.time_out
    end
  end

  # Reducing the granularity allows for a unique constraint to prevent duplicates
  def truncate_seconds
  	self.time_in = time_in.round
  end
end
