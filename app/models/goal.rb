class Goal < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_and_belongs_to_many :students

  MAX_PER_STUDENT = 3.freeze
end
