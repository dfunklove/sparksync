class CreateLessons < ActiveRecord::Migration[5.1]
  def change
    create_table :lessons do |t|
      t.references :student, foreign_key: true
      t.references :teacher, foreign_key: true
      t.datetime :timeIn
      t.datetime :timeOut
      t.boolean :broughtInstrument
      t.boolean :broughtBooks
      t.integer :progress
      t.integer :behavior
      t.text :notes

      t.timestamps
    end
  end
end
