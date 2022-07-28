class CreateGoalsStudentsJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :goals, :students do |t|
      t.index :goal_id
      t.index :student_id
    end
  end
end
