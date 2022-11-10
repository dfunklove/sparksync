# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_11_10_183050) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string "name", null: false
    t.text "notes"
    t.bigint "school_id", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "goals", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_goals_on_name", unique: true
  end

  create_table "group_lessons", force: :cascade do |t|
    t.text "notes"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", null: false
    t.datetime "time_in", precision: nil, null: false
    t.datetime "time_out", precision: nil
    t.bigint "course_id"
    t.index ["user_id", "time_in"], name: "index_group_lessons_on_user_id_and_time_in", unique: true
    t.index ["user_id"], name: "index_group_lessons_on_user_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.datetime "time_in", precision: nil, null: false
    t.datetime "time_out", precision: nil
    t.boolean "brought_instrument"
    t.boolean "brought_books"
    t.integer "progress"
    t.integer "behavior"
    t.text "notes"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", null: false
    t.bigint "school_id", null: false
    t.integer "group_lesson_id"
    t.index ["group_lesson_id"], name: "index_lessons_on_group_lesson_id"
    t.index ["school_id"], name: "index_lessons_on_school_id"
    t.index ["student_id"], name: "index_lessons_on_student_id"
    t.index ["user_id", "time_in"], name: "index_lessons_on_user_id_and_time_in", unique: true, where: "(group_lesson_id IS NULL)"
    t.index ["user_id"], name: "index_lessons_on_user_id"
  end

  create_table "logins", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "time_in", precision: nil, null: false
    t.datetime "time_out", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "score", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "goal_id"
    t.bigint "lesson_id"
    t.index ["goal_id"], name: "index_ratings_on_goal_id"
    t.index ["lesson_id"], name: "index_ratings_on_lesson_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "activated", default: true
    t.index ["name"], name: "index_schools_on_name", unique: true
  end

  create_table "student_courses", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "course_id", null: false
    t.index ["course_id"], name: "index_student_courses_on_course_id"
    t.index ["student_id"], name: "index_student_courses_on_student_id"
  end

  create_table "student_goals", force: :cascade do |t|
    t.bigint "goal_id", null: false
    t.bigint "student_id", null: false
    t.index ["goal_id", "student_id"], name: "index_student_goals_on_goal_id_and_student_id", unique: true
    t.index ["goal_id"], name: "index_student_goals_on_goal_id"
    t.index ["student_id"], name: "index_student_goals_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.bigint "school_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "activated", default: true
    t.string "permissions"
    t.index ["school_id"], name: "index_students_on_school_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "type", null: false
    t.string "password_digest", null: false
    t.boolean "activated", default: true
    t.integer "school_id"
    t.string "reset_digest"
    t.datetime "reset_sent_at", precision: nil
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "group_lessons", "courses", on_delete: :nullify
  add_foreign_key "group_lessons", "users", on_delete: :nullify
  add_foreign_key "lessons", "group_lessons", on_delete: :cascade
  add_foreign_key "lessons", "schools"
  add_foreign_key "lessons", "students", on_delete: :cascade
  add_foreign_key "lessons", "users", on_delete: :nullify
  add_foreign_key "logins", "users", on_delete: :cascade
  add_foreign_key "ratings", "goals"
  add_foreign_key "ratings", "lessons", on_delete: :cascade
  add_foreign_key "students", "schools"
end
