class ChangeAllActivatedDefaultTrue < ActiveRecord::Migration[5.1]
  def change
	change_column_default :schools, :activated, from: nil, to: true
	change_column_default :students, :activated, from: nil, to: true
	change_column_default :users, :activated, from: nil, to: true
  end
end
