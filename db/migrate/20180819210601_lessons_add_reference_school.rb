class LessonsAddReferenceSchool < ActiveRecord::Migration[5.1]
  def change
  	add_reference :lessons, :school, foreign_key: true
  end
end
