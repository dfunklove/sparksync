class Login < ApplicationRecord
  validates :user_id, presence: true
  validates :time_in, presence: true
  belongs_to :teacher, class_name: 'Teacher', foreign_key: 'user_id'
  def Login.last_login uid
    sqlstr = "SELECT * FROM logins WHERE user_id = "
    sqlstr += uid.to_s;
    sqlstr += " ORDER BY time_in DESC"
    puts "sqlstr: " + sqlstr
    rec_list = self.find_by_sql sqlstr
    return rec_list.first
  end
end
