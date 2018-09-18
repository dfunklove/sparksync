class Admin < User
  default_scope -> { order(last_name: :asc) }
end
