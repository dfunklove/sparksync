class Lesson < ApplicationRecord
  validates :school, presence: true
  validates :student, presence: true
  validates :teacher, presence: true
  validates :time_in, presence: true
  validates :time_in, uniqueness: { scope: :user_id }, if: -> { group_lesson_id.nil? }
  validates_associated :school, :student, :ratings

  DATETIME_FORMAT = "%m-%d-%Y %l:%M %p".freeze 
  TIME_FORMAT = "%l:%M %p".freeze

  belongs_to :student
  belongs_to :teacher, class_name: 'Teacher',foreign_key: 'user_id'
  belongs_to :school
  belongs_to :group_lesson, optional: true
  has_many :ratings

  accepts_nested_attributes_for :ratings, reject_if: :all_blank

  accepts_nested_attributes_for :student

  before_create :check_student_activated, :truncate_seconds

  def check_student_activated
    if !student.activated?
      errors.add(
        :base,
        :student_deactivated,
        message: "This student is deactivated")
      throw :abort
    end
  end

  # Reducing the granularity allows for a unique constraint to prevent duplicates
  def truncate_seconds
    self.time_in = time_in.round
  end

  # Populate ratings from student goals
  def get_goals_from_student
    self.student.goals.each do |goal|
      x = Rating.new
      x.goal = goal
      self.ratings << x
    end
  end

  # Overwrite student goals with those from ratings
  def save_goals_to_student
    # Clear the existing goals because we only want the new ones
    self.student.goals.clear

    # Get goal id's from the ratings and save them to the student
    self.ratings.each do |rating|
      begin
        self.student.goals << Goal.find(rating.goal.id) unless rating.goal.nil? or rating.goal.new_record?
      rescue ActiveRecord::RecordInvalid => e
        logger.error(e)
        self.errors.add(:goals, e.message)
      end
    end
  end

  def self.clean_start_date start_date
    if !start_date.respond_to?(:utc)
      start_date = start_date.to_time
    end
    return start_date
  end

  # Convert date to time explicitly because rails will set it to beginning_of_day
  def self.clean_end_date end_date
    if !end_date.respond_to?(:utc)
      end_date = end_date.to_time.end_of_day
    end
    return end_date
  end

  def self.in_progress
  	self.joins(:student).where("lessons.time_out is null AND lessons.time_in > ?", Time.new.beginning_of_day).order("students.school_id")
  end

  def self.find_by_date(start_date, end_date)
    sql = "? <= lessons.time_in and lessons.time_in <= ? and lessons.time_out is not null"
    args = [clean_start_date(start_date), clean_end_date(end_date)]
    sql += " and schools.activated = ?"
    sql += " and students.activated = ?"
    sql += " and users.activated = ?"
    args.concat([true, true, true])
    self.includes(:group_lesson, :school, :student, :teacher, ratings: [:goal]).where(sql, *args).references(:group_lesson, :school, :student, :teacher, ratings: [:goal])  end

  def self.find_by_school(school_id, start_date, end_date)
    sql = "lessons.school_id = ? and ? <= lessons.time_in and lessons.time_in <= ? and lessons.time_out is not null"
    args = [school_id, clean_start_date(start_date), clean_end_date(end_date)]
    if School.find(school_id).activated?
      sql += " and students.activated = ?"
      sql += " and users.activated = ?"
      args.concat([true, true])
    end
    self.includes(:group_lesson, :student, :teacher, ratings: [:goal]).where(sql, *args).references(:group_lesson, :student, :teacher, ratings: [:goal])
  end

  def self.find_by_student(student_id, start_date, end_date)
    sql = "lessons.student_id = ? and ? <= lessons.time_in and lessons.time_in <= ? and lessons.time_out is not null"
    args = [student_id, clean_start_date(start_date), clean_end_date(end_date)]
    if Student.find(student_id).activated?
      sql += " and schools.activated = ?"
      sql += " and users.activated = ?"
      args.concat([true, true])
    end
    self.includes(:group_lesson, :school, :teacher, ratings: [:goal]).where(sql, *args).references(:group_lesson, :school, :teacher, ratings: [:goal])
  end

  def self.find_by_teacher(teacher_id, start_date, end_date)
    sql = "lessons.user_id = ? and ? <= lessons.time_in and lessons.time_in <= ? and lessons.time_out is not null"
    args = [teacher_id, clean_start_date(start_date), clean_end_date(end_date)]
    if Teacher.find(teacher_id).activated?
      sql += " and schools.activated = ?"
      sql += " and students.activated = ?"
      args.concat([true, true])
    end
    self.includes(:group_lesson, :school, :student, ratings: [:goal]).where(sql, *args).references(:group_lesson, :school, :student, ratings: [:goal])
  end
end
