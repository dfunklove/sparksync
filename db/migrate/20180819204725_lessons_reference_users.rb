class LessonsReferenceUsers < ActiveRecord::Migration[5.1]
  def change
  	add_reference :lessons, :users
  end
end
