class AddUniqueIndexStudentGoals < ActiveRecord::Migration[5.1]
  def change
    add_index :student_goals, [:goal_id, :student_id], unique: true
  end
end
