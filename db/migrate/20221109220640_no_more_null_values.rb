class NoMoreNullValues < ActiveRecord::Migration[5.1]
  def change
    change_column_null :group_lessons, :time_in, false

    change_column_null :logins, :user_id, false
    change_column_null :logins, :time_in, false

    change_column_null :students, :first_name, false
    change_column_null :students, :last_name, false
    change_column_null :students, :school_id, false

    change_column_null :users, :first_name, false
    change_column_null :users, :last_name, false
    change_column_null :users, :email, false
    change_column_null :users, :type, false
    change_column_null :users, :password_digest, false
  end
end

