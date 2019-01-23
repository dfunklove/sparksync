class AddUniqueNameIndexToSchool < ActiveRecord::Migration[5.1]
  def change
  	add_index :schools, :name, unique:true
  end
end
