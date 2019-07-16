class AddTimestampsToGroupLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :group_lessons, :time_in, :datetime
    add_column :group_lessons, :time_out, :datetime
  end
end
