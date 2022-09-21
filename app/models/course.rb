class Course < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: [:school, :teacher] }
  validates :school, presence: true
  validates :start_date, presence: true
  validates :teacher, presence: true
  validates :students, length: { minimum: 2, message: "Please select two or more students" }
  validate :start_date_before_end_date

  belongs_to :school
  belongs_to :teacher, class_name: 'Teacher',foreign_key: 'user_id'

  has_many :student_courses
  has_many :students, through: :student_courses

  def start_date_before_end_date
    if end_date && end_date <= start_date
      errors.add(:start_date, "must be earlier than end date")
    end
  end
end
