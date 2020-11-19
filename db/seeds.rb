# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin1 = Admin.create!(  first_name: "Cynthia",
  last_name: "Smith",
  email: "cynthia@sparksforsuccess.org",
  password: "sparksISgr8*",
  password_confirmation: "sparksISgr8*",
  type: "Admin",
  activated: true )

admin2 = Admin.create!(  first_name: "Chris",
  last_name: "Smith",
  email: "chris.smith@pelotonu.org",
  password: "sparksISgr8*",
  password_confirmation: "sparksISgr8*",
  type: "Admin",
  activated: true )

teacher1 = Teacher.create!(  first_name: "Ima",
  last_name: "Test",
  email: "test@example.com",
  password: "sparksISgr8*",
  password_confirmation: "sparksISgr8*",
  type: "Teacher",
  activated: true )

school1 = School.create!( name: "Blackshear", activated: true)
school2 = School.create!( name: "Kealing", activated: true)
school3 = School.create!( name: "Oak Springs", activated: true)
school4 = School.create!( name: "Zavala", activated: true)
