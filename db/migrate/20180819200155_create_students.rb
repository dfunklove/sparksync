class CreateStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :students do |t|
      t.string :firstName
      t.string :lastName
      t.references :school, foreign_key: true

      t.timestamps
    end
  end
end
