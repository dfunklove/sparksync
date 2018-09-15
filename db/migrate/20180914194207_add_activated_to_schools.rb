class AddActivatedToSchools < ActiveRecord::Migration[5.1]
  def change
    add_column :schools, :activated, :boolean
  end
end
