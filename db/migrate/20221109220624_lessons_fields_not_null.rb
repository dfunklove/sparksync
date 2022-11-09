class LessonsFieldsNotNull < ActiveRecord::Migration[5.1]
  def change
    change_column_null :lessons, :student_id, false
    change_column_null :lessons, :time_in, false
    change_column_null :lessons, :school_id, false
  end
end
