class GoalNameNotNull < ActiveRecord::Migration[5.1]
  def change
    change_column_null :goals, :name, false
  end
end
