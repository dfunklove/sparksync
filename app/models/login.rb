class Login < ApplicationRecord
  validates :user_id, presence: true
  validates :time_in, presence: true
  belongs_to :teacher, class_name: 'Teacher', foreign_key: 'user_id'
  default_scope -> { order(created_at: :desc) }
end
