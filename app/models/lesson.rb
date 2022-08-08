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

  def self.in_progress
  	self.joins(:student).where("lessons.time_out is null AND lessons.time_in > ?", Time.new.beginning_of_day).order("students.school_id")
  end

  def self.find_by_date(start_date, end_date)
    sql = "select users.first_name, users.last_name as teacher_last, "
    sql += "time_in, time_out, progress, behavior, notes, brought_instrument, "
    sql += "brought_books, lessons.id, lessons.school_id, name, "
    sql += "students.first_name, "
    sql += "students.last_name as student_last, user_id, student_id, group_lesson_id "
    sql += "from users inner join lessons on users.id = lessons.user_id "
    sql += " inner join students on lessons.student_id = students.id "
    sql += " inner join schools on lessons.school_id = schools.id "
    sql += "where time_out is not null"
    sql += " and ? <= time_in and time_in <= ? "
    sql += " and students.activated = true"
    sql += " and users.activated = true"
    sql += " and schools.activated = true"
    self.find_by_sql([sql, start_date.to_s, end_date.to_s])
  end

  def self.find_by_school(school_id, start_date, end_date)
    school = School.find(school_id)
    sql = "select users.first_name, users.last_name as teacher_last, "
    sql += "time_in, time_out, progress, behavior, notes, brought_instrument, "
    sql += "brought_books, students.first_name, "
    sql += "students.last_name as student_last, user_id, student_id, group_lesson_id "
    sql += "from users inner join lessons on users.id = lessons.user_id "
    sql += " inner join students on lessons.student_id = students.id "
    sql += "where time_out is not null and lessons.school_id = " + school_id 
    sql += " and ? <= time_in and time_in <= ? "
    if school.activated?
      sql += " and students.activated = true"
      sql += " and users.activated = true"
    end
    self.find_by_sql([sql, start_date.to_s, end_date.to_s])    
  end

  def self.find_by_student(student_id, start_date, end_date)
    student = Student.find(student_id)
    sql = "select users.first_name, users.last_name as teacher_last, "
    sql += "time_in, time_out, progress, behavior, notes, brought_instrument, "
    sql += "brought_books, schools.name, user_id, student_id, lessons.school_id, group_lesson_id "
    sql += "from users inner join lessons on users.id = lessons.user_id "
    sql += " inner join students on lessons.student_id = students.id "
    sql += " inner join schools on students.school_id = schools.id "
    sql += "where time_out is not null and lessons.student_id = " + student_id 
    sql += " and ? <= time_in and time_in <= ? "
    if student.activated?
      sql += " and users.activated = true"
      sql += " and schools.activated = true"
    end
    self.find_by_sql([sql, start_date.to_s, end_date.to_s])
  end

  def self.find_by_teacher(teacher_id, start_date, end_date)
    sql = "lessons.user_id = ? and ? <= lessons.time_in and lessons.time_in <= ? and lessons.time_out is not null"
    args = [teacher_id, start_date.to_s, end_date.to_s]
    if Teacher.find(teacher_id).activated?
      sql += " and students.activated = ?"
      sql += " and schools.activated = ?"
      args.concat([true, true])
    end
    self.includes(:group_lesson, :student, :school, ratings: [:goal]).where(sql, *args).references(:group_lesson, :student, :school, ratings: [:goal])
  end
end
