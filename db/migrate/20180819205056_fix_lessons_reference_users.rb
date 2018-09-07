class FixLessonsReferenceUsers < ActiveRecord::Migration[5.1]
  def change
  	remove_reference :lessons, :users
    add_reference :lessons, :user, foreign_key: {on_delete: :nullify}
  end
end
