# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190714191757) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "group_lessons", force: :cascade do |t|
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lessons", force: :cascade do |t|
    t.bigint "student_id"
    t.datetime "time_in"
    t.datetime "time_out"
    t.boolean "brought_instrument"
    t.boolean "brought_books"
    t.integer "progress"
    t.integer "behavior"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "school_id"
    t.integer "group_lesson_id"
    t.index ["group_lesson_id"], name: "index_lessons_on_group_lesson_id"
    t.index ["school_id"], name: "index_lessons_on_school_id"
    t.index ["student_id"], name: "index_lessons_on_student_id"
    t.index ["user_id"], name: "index_lessons_on_user_id"
  end

  create_table "logins", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "time_in"
    t.datetime "time_out"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schools", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "activated"
    t.index ["name"], name: "index_schools_on_name", unique: true
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.bigint "school_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "activated"
    t.index ["school_id"], name: "index_students_on_school_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.string "password_digest"
    t.boolean "activated"
    t.integer "school_id"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "lessons", "schools"
  add_foreign_key "lessons", "students", on_delete: :cascade
  add_foreign_key "lessons", "users", on_delete: :nullify
  add_foreign_key "logins", "users", on_delete: :cascade
  add_foreign_key "students", "schools"
end
