class Partner < User
  validates :school_id, presence: true
  default_scope -> { order(last_name: :asc) }
  has_one :school
  default_scope -> { order(last_name: :asc) }
end
