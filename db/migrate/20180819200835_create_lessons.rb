class CreateLessons < ActiveRecord::Migration[5.1]
  def change
    create_table :lessons do |t|
      t.references :student, foreign_key: {on_delete: :cascade}
      t.references :teacher, foreign_key: true
      t.datetime :time_in
      t.datetime :time_out
      t.boolean :brought_instrument
      t.boolean :brought_books
      t.integer :progress
      t.integer :behavior
      t.text :notes

      t.timestamps
    end
  end
end
