class StudentCourse < ApplicationRecord
  belongs_to :student
  belongs_to :course

  validates :student_id, uniqueness: {scope: :course_id, message: "student already enrolled in course" }
end