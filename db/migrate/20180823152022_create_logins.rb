class CreateLogins < ActiveRecord::Migration[5.1]
  def change
    create_table :logins do |t|
      t.integer :user_id
      t.datetime :time_in
      t.datetime :time_out

      t.timestamps
    end
    add_foreign_key "logins", "users", on_delete: :cascade
  end
end
