class ChangeColumnSchoolNameNotNull < ActiveRecord::Migration[5.1]
  def change
	change_column_null :schools, :name, false, ""
  end
end
