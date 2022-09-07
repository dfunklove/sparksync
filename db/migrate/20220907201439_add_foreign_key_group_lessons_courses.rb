class AddForeignKeyGroupLessonsCourses < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :group_lessons, :courses, on_delete: :nullify
  end
end
