class Rating < ApplicationRecord
  validates :goal, presence: true
  validates :lesson, presence: true
  validates :score, presence: { message: "Every goal needs a rating"}

  belongs_to :goal
  belongs_to :lesson

  accepts_nested_attributes_for :goal, reject_if: :new_record?
end
