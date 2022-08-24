class Course < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :school, presence: true
  validates :start_date, presence: true
  validates :teacher, presence: true
  validates :students, length: { minimum: 2, message: "must number at least 2" }

  belongs_to :school
  belongs_to :teacher, class_name: 'Teacher',foreign_key: 'user_id'

  has_many :student_courses
  has_many :students, through: :student_courses
end
