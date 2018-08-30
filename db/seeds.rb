# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create!(  firstName: "Jane",
  lastName: "Bennet",
  email: "janeB@yahoo.edu",
  password: "testjane",
  password_confirmation: "testjane",
  id: 9,
  type: "Admin" )

Admin.create!(  firstName: "William",
  lastName: "Collins",
  email: "billC@yahoo.edu",
  password: "testbill",
  password_confirmation: "testbill",
  id: 13,
  type: "Admin" )

Teacher.create!(  firstName: "Charlotte",
  lastName: "Lucas",
  email: "charL@yahoo.edu",
  password: "testchar",
  password_confirmation: "testchar",
  id: 35,
  type: "Teacher" )

Teacher.create!(  firstName: "Caroline",
  lastName: "Bingley",
  email: "caroB@yahoo.edu",
  password: "testcaro",
  password_confirmation: "testcaro",
  id: 47,
  type: "Teacher" )

School.create!( name: "Blackshear")
School.create!( name: "Kealing")
School.create!( name: "Oak Springs")
School.create!( name: "Zavala")

Student.create!( firstName: "Byron",
  lastName: "Watson",
  school_id: 1 )

Student.create!( firstName: "Lucy",
  lastName: "Pevensie",
  school_id: 4 )

Student.create!( firstName: "Veruca",
  lastName: "Salt",
  school_id: 3 )

Student.create!( firstName: "Dallas",
  lastName: "Winston",
  school_id: 2 )

Student.create!( firstName: "Frank",
  lastName: "Anderson",
  school_id: 2 )

Student.create!( firstName: "Ramona",
  lastName: "Quimby",
  school_id: 4 )

Student.create!( firstName: "Rubeus",
  lastName: "Hagrid",
  school_id: 1 )

Student.create!( firstName: "Fern",
  lastName: "Arable",
  school_id: 3 )

Student.create!( firstName: "Harold",
  lastName: "Johnson",
  school_id: 3 )

Student.create!( firstName: "Homer",
  lastName: "Zuckerman",
  school_id: 3 )
