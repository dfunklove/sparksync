class Lesson < ApplicationRecord
  belongs_to :student
  belongs_to :teacher, class_name: 'Teacher', foreign_key: 'user_id'
  belongs_to :school
end
