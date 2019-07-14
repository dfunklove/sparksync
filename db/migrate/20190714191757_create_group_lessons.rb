class CreateGroupLessons < ActiveRecord::Migration[5.1]
  def change
    create_table :group_lessons do |t|
      t.text :notes

      t.timestamps
    end

    add_column :lessons, :group_lesson_id, :integer
    add_index :lessons, :group_lesson_id
  end
end
