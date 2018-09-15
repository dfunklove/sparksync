# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create!(  first_name: "Jane",
  last_name: "Bennet",
  email: "janeB@yahoo.edu",
  password: "testjane",
  password_confirmation: "testjane",
  id: 9,
  type: "Admin",
  activated: true )

Admin.create!(  first_name: "William",
  last_name: "Collins",
  email: "billC@yahoo.edu",
  password: "testbill",
  password_confirmation: "testbill",
  id: 13,
  type: "Admin",
  activated: true )


Partner.create!(  first_name: "Miss",
  last_name: "Clavel",
  email: "missC@yahoo.edu",
  password: "testmiss",
  password_confirmation: "testmiss",
  id: 17,
  school_id: 2,
  type: "Partner",
  activated: true )

Teacher.create!(  first_name: "Charlotte",
  last_name: "Lucas",
  email: "charL@yahoo.edu",
  password: "testchar",
  password_confirmation: "testchar",
  id: 35,
  type: "Teacher",
  activated: true )

Teacher.create!(  first_name: "Caroline",
  last_name: "Bingley",
  email: "caroB@yahoo.edu",
  password: "testcaro",
  password_confirmation: "testcaro",
  id: 47,
  type: "Teacher",
  activated: true )

School.create!( name: "Blackshear", id: 1, activated: true)
School.create!( name: "Kealing", id: 2, activated: true)
School.create!( name: "Oak Springs", id: 3, activated: true)
School.create!( name: "Zavala", id: 4, activated: true)

Student.create!( first_name: "Byron",
  last_name: "Watson",
  school_id: 1 )

Student.create!( first_name: "Lucy",
  last_name: "Pevensie",
  school_id: 4 )

Student.create!( first_name: "Veruca",
  last_name: "Salt",
  school_id: 3 )

Student.create!( first_name: "Dallas",
  last_name: "Winston",
  school_id: 2 )

Student.create!( first_name: "Frank",
  last_name: "Anderson",
  school_id: 2 )

Student.create!( first_name: "Ramona",
  last_name: "Quimby",
  school_id: 4 )

Student.create!( first_name: "Ron",
  last_name: "Howard",
  school_id: 1 )

Student.create!( first_name: "Rubeus",
  last_name: "Hagrid",
  school_id: 1 )

Student.create!( first_name: "Fern",
  last_name: "Arable",
  school_id: 3 )

Student.create!( first_name: "Harold",
  last_name: "Johnson",
  school_id: 3 )

Student.create!( first_name: "Homer",
  last_name: "Zuckerman",
  school_id: 3 )

Student.create!( first_name: "Frances",
  last_name: "Hoban",
  school_id: 4 )

Login.create(
  time_in: Time.now - 30*60, 
  time_out: Time.now, 
  user_id: 47)

Login.create(
  time_in: Time.now - 24*60*60 - 45*60, 
  time_out: Time.now - 24*60*60, 
  user_id: 47)

Login.create(
  time_in: Time.now - 2*24*60*60 - 25*60, 
  time_out: Time.now - 2*24*60*60, 
  user_id: 47)

Login.create(
  time_in: Time.now - 3*24*60*60 - 35*60, 
  time_out: Time.now - 3*24*60*60, 
  user_id: 47)

Login.create(
  time_in: Time.now - 5*60, 
  time_out: Time.now, 
  user_id: 35)

Lesson.create!(student_id: 3, 
  time_in: DateTime.new( 2018, 9, 7, 14, 30),
  time_out: DateTime.new( 2018, 9, 7, 15, 00),
  brought_instrument: true,
  brought_books: false,
  progress: 3, 
  behavior: 2,
  notes: "cranky",
  user_id: 47,
  school_id: 3)

Lesson.create!(student_id: 9, 
  time_in: DateTime.new( 2018, 9, 7, 15, 00),
  time_out: DateTime.new( 2018, 9, 7, 15, 30),
  brought_instrument: true,
  brought_books: false,
  progress: 3, 
  behavior: 2,
  notes: "surly",
  user_id: 47,
  school_id: 3)

Lesson.create!(student_id: 4, 
  time_in: DateTime.new( 2018, 9, 7, 14, 30),
  time_out: DateTime.new( 2018, 9, 7, 15, 00),
  brought_instrument: true,
  brought_books: false,
  progress: 3, 
  behavior: 2,
  notes: "disrespectful and inattentive",
  user_id: 35,
  school_id: 2)

Lesson.create!(student_id: 5, 
  time_in: DateTime.new( 2018, 9, 7, 15, 00),
  time_out: DateTime.new( 2018, 9, 7, 15, 30),
  brought_instrument: true,
  brought_books: false,
  progress: 3, 
  behavior: 2,
  notes: "same as usual",
  user_id: 35,
  school_id: 2)

Lesson.create!(student_id: 5, 
  time_in: DateTime.new( 2018, 9, 10, 14, 30),
  time_out: DateTime.new( 2018, 9, 10, 15, 00),
  brought_instrument: true,
  brought_books: false,
  progress: 3, 
  behavior: 2,
  notes: "mopey",
  user_id: 47,
  school_id: 2)

Lesson.create!(student_id: 4, 
  time_in: DateTime.new( 2018, 9, 10, 15, 00),
  time_out: DateTime.new( 2018, 9, 10, 15, 30),
  brought_instrument: true,
  brought_books: false,
  progress: 3, 
  behavior: 2,
  notes: "distracted",
  user_id: 47,
  school_id: 2)

Lesson.create!(student_id: 3, 
  time_in: DateTime.new( 2018, 9, 10, 14, 30),
  time_out: DateTime.new( 2018, 9, 10, 15, 00),
  brought_instrument: true,
  brought_books: false,
  progress: 3, 
  behavior: 2,
  notes: "not at her best",
  user_id: 35,
  school_id: 3)

Lesson.create!(student_id: 9, 
  time_in: DateTime.new( 2018, 9, 10, 15, 00),
  time_out: DateTime.new( 2018, 9, 10, 15, 30),
  brought_instrument: true,
  brought_books: false,
  progress: 3, 
  behavior: 2,
  notes: "ok",
  user_id: 35,
  school_id: 3)

Lesson.create!(student_id: 1, 
  time_in: DateTime.new( 2018, 9, 11, 14, 30),
  time_out: DateTime.new( 2018, 9, 11, 15, 00),
  brought_instrument: true,
  brought_books: true,
  progress: 5, 
  behavior: 5,
  notes: "excellent",
  user_id: 47,
  school_id: 1)

Lesson.create!(student_id: 7, 
  time_in: DateTime.new( 2018, 9, 11, 15, 00),
  time_out: DateTime.new( 2018, 9, 11, 15, 30),
  brought_instrument: true,
  brought_books: true,
  progress: 5, 
  behavior: 5,
  notes: "great!",
  user_id: 47,
  school_id: 1)

Lesson.create!(student_id: 2, 
  time_in: DateTime.new( 2018, 9, 11, 14, 00),
  time_out: DateTime.new( 2018, 9, 11, 15, 00),
  brought_instrument: true,
  brought_books: true,
  progress: 3, 
  behavior: 4,
  notes: "sleepy",
  user_id: 35,
  school_id: 4)

Lesson.create!(student_id: 12, 
  time_in: DateTime.new( 2018, 9, 11, 15, 00),
  time_out: DateTime.new( 2018, 9, 11, 15, 30),
  brought_instrument: true,
  brought_books: true,
  progress: 3, 
  behavior: 4,
  notes: "broke a string",
  user_id: 35,
  school_id: 4)

Lesson.create!(student_id: 4, 
  time_in: DateTime.new( 2018, 9, 12, 14, 30),
  time_out: DateTime.new( 2018, 9, 12, 15, 00),
  brought_instrument: true,
  brought_books: true,
  progress: 3, 
  behavior: 4,
  notes: "doing better",
  user_id: 47,
  school_id: 2)

Lesson.create!(student_id: 5, 
  time_in: DateTime.new( 2018, 9, 12, 15, 00),
  time_out: DateTime.new( 2018, 9, 12, 15, 30),
  brought_instrument: true,
  brought_books: false,
  progress: 5, 
  behavior: 2,
  notes: "fine",
  user_id: 47,
  school_id: 2)

Lesson.create!(student_id: 10, 
  time_in: Time.now - 5*60*60,
  brought_instrument: true,
  brought_books: true,
  user_id: 47,
  school_id: 3)

Lesson.create!(student_id: 12, 
  time_in: Time.now - 5*60*60,
  brought_instrument: true,
  brought_books: true,
  user_id: 35,
  school_id: 4)

