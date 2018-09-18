class AddActivatedToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :activated, :boolean
  end
end
