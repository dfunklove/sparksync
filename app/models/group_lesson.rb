class GroupLesson < ApplicationRecord
  has_many :lessons, dependent: destroy
end
