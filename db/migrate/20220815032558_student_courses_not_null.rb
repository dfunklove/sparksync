class StudentCoursesNotNull < ActiveRecord::Migration[5.1]
  def change
    change_column_null :student_courses, :student_id, false
    change_column_null :student_courses, :course_id, false
  end
end
