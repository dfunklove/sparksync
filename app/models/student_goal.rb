class StudentGoal < ApplicationRecord
  belongs_to :student
  belongs_to :goal

  validates :student_id, uniqueness: {scope: :goal_id, message: "goals must be unique" }
end