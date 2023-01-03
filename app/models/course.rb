class Course < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :school, presence: true
  validates :start_date, presence: true
  validates :teacher, presence: true
  validate :min_students
  validate :start_date_before_end_date

  belongs_to :school
  belongs_to :teacher, class_name: 'Teacher',foreign_key: 'user_id'

  has_many :student_courses
  has_many :students, through: :student_courses

  def min_students
    if students.length < 2
      errors.add(:base, "Please select two or more students")
    end
  end

  def start_date_before_end_date
    if end_date && end_date <= start_date
      errors.add(:start_date, "must be earlier than end date")
    end
  end
end
