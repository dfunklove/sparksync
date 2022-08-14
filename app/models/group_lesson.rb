class GroupLesson < ApplicationRecord
  has_many :lessons, dependent: :destroy
  belongs_to :teacher, class_name: 'Teacher',foreign_key: 'user_id'

  validates :teacher, presence: true
  validates :time_in, uniqueness: { scope: :user_id }
  validates_associated :lessons

  accepts_nested_attributes_for :lessons

  # Reducing the granularity allows for a unique constraint to prevent duplicates
  def truncate_seconds
  	self.time_in = time_in.round
  end
end
