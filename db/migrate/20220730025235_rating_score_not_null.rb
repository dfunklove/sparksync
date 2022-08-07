class RatingScoreNotNull < ActiveRecord::Migration[5.1]
  def change
    change_column_null :ratings, :score, false
  end
end
