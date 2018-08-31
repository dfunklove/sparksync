class Teacher < User
	has_many :lessons, foreign_key: 'user_id'

	def lessons_in_progress
		self.lessons.where(timeOut: nil)
	end
end
