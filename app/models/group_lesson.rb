class GroupLesson < ApplicationRecord
  has_many :lessons, dependent: :destroy
  belongs_to :teacher, class_name: 'Teacher',foreign_key: 'user_id'

  validates :teacher, presence: true
  validates_associated :lessons

  accepts_nested_attributes_for :lessons
end
