class Goal < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :student_goals
  has_many :students, through: :student_goals

  MAX_PER_STUDENT = 3.freeze
end
