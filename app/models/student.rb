class Student < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :last_name, uniqueness: {scope: [:first_name, :school_id] }

  belongs_to :school
  has_many :lessons
  default_scope -> { order(last_name: :asc) }

end
