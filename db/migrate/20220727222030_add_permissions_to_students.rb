class AddPermissionsToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :permissions, :string
  end
end
