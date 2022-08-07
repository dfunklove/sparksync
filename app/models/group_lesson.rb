class GroupLesson < ApplicationRecord
  has_many :lessons, dependent: :destroy
  belongs_to :teacher, class_name: 'Teacher',foreign_key: 'user_id'

  validates :teacher, presence: true
  validates :time_in, uniqueness: { scope: :user_id }
  validates_associated :lessons

  accepts_nested_attributes_for :lessons

  before_create :populate_school_id,:truncate_seconds

  # Use the school_id from the first lesson (student)
  def populate_school_id
    if !self.school_id and !self.lessons.empty?
      self.school_id = self.lessons[0].school_id
    end
  end

  # Reducing the granularity allows for a unique constraint to prevent duplicates
  def truncate_seconds
  	self.time_in = time_in.round
  end
end
