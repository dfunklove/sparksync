class Login < ApplicationRecord
  validates :user_id, presence: true
  validates :time_in, presence: true
  belongs_to :teacher, class_name: 'Teacher', foreign_key: 'user_id'
  default_scope -> { order(time_in: :desc) }

  before_create :close_last

  private
  	# Close out the last login if needed
  	def close_last
  		last = self.teacher.last_login
  		if (last && last.time_out == nil)
  			last.time_out = Time.now
  			last.save
  		end
  	end
end
