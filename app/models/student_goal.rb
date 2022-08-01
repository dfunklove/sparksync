class StudentGoal < ApplicationRecord
  belongs_to :student
  belongs_to :goal
end