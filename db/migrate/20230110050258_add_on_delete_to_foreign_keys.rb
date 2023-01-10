class AddOnDeleteToForeignKeys < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key "lessons", "schools"
    add_foreign_key "lessons", "schools", on_delete: :nullify
    remove_foreign_key "ratings", "goals"
    add_foreign_key "ratings", "goals", on_delete: :cascade
    remove_foreign_key "students", "schools"
    add_foreign_key "students", "schools", on_delete: :nullify
  end
end
