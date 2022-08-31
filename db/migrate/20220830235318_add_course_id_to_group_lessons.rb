class AddCourseIdToGroupLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :group_lessons, :course_id, :bigint
  end
end
