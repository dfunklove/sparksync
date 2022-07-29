class Rating < ApplicationRecord
  belongs_to :goal
  belongs_to :lesson
  belongs_to :student
end
