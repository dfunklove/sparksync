class AddRefsToRating < ActiveRecord::Migration[5.1]
  def change
    add_reference :ratings, :goal, foreign_key: true
    add_reference :ratings, :lesson, foreign_key: true
  end
end
