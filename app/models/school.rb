class School < ApplicationRecord
  validates :name, presence: true
  
  has_many :students
  has_many :lessons
  default_scope -> { order(name: :asc) }

  def activeschools
    schools.where(activated == true)
  end
end
