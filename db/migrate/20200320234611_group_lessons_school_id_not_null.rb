class GroupLessonsSchoolIdNotNull < ActiveRecord::Migration[5.1]
  def change
    GroupLesson.all.each do |g|
        if g.school_id == nil
            if g.lessons.size == 0 || g.lessons.first.school_id == nil
                g.school_id = School.first.id
            else
                g.school_id = g.lessons.first.school_id
            end
            g.save
        end
    end
    change_column_null :group_lessons, :school_id, false
  end
end
