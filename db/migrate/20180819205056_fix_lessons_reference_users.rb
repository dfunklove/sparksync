class FixLessonsReferenceUsers < ActiveRecord::Migration[5.1]
  def change
  	remove_reference :lessons, :users
  	add_reference :lessons, :user, foreign_key: true
  end
end
