# Migrate from has_and_belongs_to_many to has_many :through
class RenameGoalsStudentsAddPrimaryKey < ActiveRecord::Migration[5.1]
  def change
    rename_table 'goals_students', 'student_goals'
    add_column :student_goals, :id, :primary_key
  end
end
