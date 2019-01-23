class ChangeColumnSchoolNameUniqueTrue < ActiveRecord::Migration[5.1]
  def change
  	change_column :schools, :name, :string, unique: true
  end
end
