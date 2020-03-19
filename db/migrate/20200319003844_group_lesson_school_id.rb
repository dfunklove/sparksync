class GroupLessonSchoolId < ActiveRecord::Migration[5.1]
  def change
    add_column :group_lessons, :school_id, :integer
  end
end
