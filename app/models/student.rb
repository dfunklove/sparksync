class Student < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :last_name, uniqueness: {scope: [:first_name, :school_id] }

  belongs_to :school
  has_many :lessons
  has_many :student_goals
  has_many :goals, through: :student_goals
  default_scope -> { order(last_name: :asc) }

  before_save :check_school_activated, if :activated_changed?

  # Do not allow students to be activated if their school is deactivated
  private
    def check_school_activated
      if !school.activated? && activated_change[1] == true
        errors.add(
          :base,
          :student_deactivated,
          message: "This student cannot be activated because their school is deactivated")
        throw :abort
      end
    end
  end

  def self.find_by_name(first_name, last_name, school_id)
    self.where('"last_name" ilike ?', last_name + "%").where('"first_name" ilike ?', first_name + "%").where( school_id: school_id)
  end

  def self.find_by_school(school_id)
    self.where(school_id: school_id, activated: true)
  end

  def self.find_by_teacher(teacher_id)
    sql = "select student_id from lessons where user_id = ?"
    rightids = Lesson.find_by_sql([sql, teacher_id]).map(&:student_id)
    rightids &= self.where(activated: true).ids
    self.where({id: rightids})    
  end
end
