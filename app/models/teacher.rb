class Teacher < User
	has_many :lessons, dependent: :nullify, foreign_key: 'user_id'
	has_many :logins, foreign_key: 'user_id'
  default_scope -> { order(lastName: :asc) }

	def lessons_in_progress
		self.lessons.where(timeOut: nil)
	end
end
