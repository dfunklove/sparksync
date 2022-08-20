class Course < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :school, presence: true
  validates :start_date, presence: true
  validates :teacher, presence: true

  belongs_to :school
  belongs_to :teacher, class_name: 'Teacher',foreign_key: 'user_id'

  has_many :student_courses
  has_many :students, through: :student_courses
end
