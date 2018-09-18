class Student < ApplicationRecord
  belongs_to :school
  has_many :lessons
  default_scope -> { order(last_name: :asc) }

end
