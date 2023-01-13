class Student < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :last_name, uniqueness: {scope: [:first_name, :school_id] }
  validates :school_id, presence: true

  belongs_to :school
  has_many :lessons
  has_many :student_courses
  has_many :courses, through: :student_courses
  has_many :student_goals
  has_many :goals, through: :student_goals
  accepts_nested_attributes_for :goals, reject_if: :all_blank
  default_scope -> { order(last_name: :asc) }

  before_save :check_school_activated, if :activated_changed?

  def name
    return "#{first_name} #{last_name}"
  end

  # Do not allow students to be activated if their school is deactivated
  private
    def check_school_activated
      if !school.activated?
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
    part1 = self.joins(:lessons).includes(:school, :goals).where(activated: true).where("lessons.user_id" => teacher_id).references(:school, :goals).order(:school_id, :last_name, :first_name, "goals.name")
    part2 = self.joins(:courses, :student_courses).includes(:school, :goals).where(activated: true).where("courses.user_id" => teacher_id).where("student_courses.course_id = courses.id").references(:school, :goals).order(:school_id, :last_name, :first_name, "goals.name")
    return (part1 + part2).uniq
  end
end
