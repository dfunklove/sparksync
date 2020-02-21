class AddIndexGroupLessonsUserTimeInUnique < ActiveRecord::Migration[5.1]
  def change
    add_index :group_lessons, [:user_id, :time_in], unique: true
    add_index :lessons, [:user_id, :time_in], unique: true, where: "group_lesson_id IS NULL"
  end
end
