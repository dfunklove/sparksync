class School < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
  has_many :students
  has_many :lessons
  default_scope -> { order(name: :asc) }

  after_update :update_students_activation, if :activated_changed?

  private
    def update_students_activation
      # cascade activated value to all students at this school
      # this prevents teachers having access to these students
      self.students.update_all(activated: activated)
    end
  end
end
