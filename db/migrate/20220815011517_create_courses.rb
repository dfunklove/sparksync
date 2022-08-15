class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string "name", null: false
      t.text "notes"
      t.bigint "school_id", null: false
      t.date "start_date", null: false
      t.date "end_date"
      t.bigint "user_id", null: false
      t.timestamps
    end
  end
end
