class AddForeignKeyLessonsGroupLessons < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :lessons, :group_lessons, on_delete: :cascade
  end
end
