class DropTeacherTable < ActiveRecord::Migration[5.1]
  def change
  	remove_foreign_key :lessons, :teachers
  	drop_table :teachers do |t|
	    t.string "firstName"
	    t.string "lastName"
	    t.string "email"
	    t.string "password_digest"
	    t.datetime "created_at", null: false
	    t.datetime "updated_at", null: false
  	end
  end
end
