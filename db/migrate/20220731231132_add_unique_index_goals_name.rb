class AddUniqueIndexGoalsName < ActiveRecord::Migration[5.1]
  def change
    add_index :goals, :name, unique: true
  end
end
