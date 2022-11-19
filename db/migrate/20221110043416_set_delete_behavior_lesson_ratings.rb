class SetDeleteBehaviorLessonRatings < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :ratings, :lessons
    add_foreign_key :ratings, :lessons, on_delete: :cascade
  end
end
