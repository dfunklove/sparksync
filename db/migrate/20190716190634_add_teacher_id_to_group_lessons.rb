class AddTeacherIdToGroupLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :group_lessons, :user_id, :bigint
    add_index :group_lessons, :user_id
  end
end
