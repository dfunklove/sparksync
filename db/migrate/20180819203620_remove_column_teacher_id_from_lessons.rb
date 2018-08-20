class RemoveColumnTeacherIdFromLessons < ActiveRecord::Migration[5.1]
  def change
  	remove_column :lessons, :teacher_id, :bigint
  end
end
