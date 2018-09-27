# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin1 = Admin.create!(  first_name: "Jane",
  last_name: "Bennet",
  email: "janeB@yahoo.edu",
  password: "testjane",
  password_confirmation: "testjane",
  type: "Admin",
  activated: true )

admin2 = Admin.create!(  first_name: "William",
  last_name: "Collins",
  email: "billC@yahoo.edu",
  password: "testbill",
  password_confirmation: "testbill",
  type: "Admin",
  activated: true )


teacher1 = Teacher.create!(  first_name: "Charlotte",
  last_name: "Lucas",
  email: "charL@yahoo.edu",
  password: "testchar",
  password_confirmation: "testchar",
  type: "Teacher",
  activated: true )

teacher2 = Teacher.create!(  first_name: "Caroline",
  last_name: "Bingley",
  email: "caroB@yahoo.edu",
  password: "testcaro",
  password_confirmation: "testcaro",
  type: "Teacher",
  activated: true )

teacher3 = Teacher.create!(  first_name: "Kitty",
  last_name: "Bennet",
  email: "kittB@yahoo.edu",
  password: "testkitt",
  password_confirmation: "testkitt",
  type: "Teacher",
  activated: true )

teacher4 = Teacher.create!(  first_name: "Eleanor",
  last_name: "Dashwood",
  email: "elean@yahoo.edu",
  password: "testelea",
  password_confirmation: "testelea",
  type: "Teacher",
  activated: true )

teacher5 = Teacher.create!(  first_name: "Lucy",
  last_name: "Steele",
  email: "lucyS@yahoo.edu",
  password: "testlucy",
  password_confirmation: "testlucy",
  type: "Teacher",
  activated: true )

school1 = School.create!( name: "Blackshear", activated: true)
school2 = School.create!( name: "Kealing", activated: true)
school3 = School.create!( name: "Oak Springs", activated: true)
school4 = School.create!( name: "Zavala", activated: true)

partner1 = Partner.create!(  first_name: "Miss",
  last_name: "Clavel",
  email: "missC@yahoo.edu",
  password: "testmiss",
  password_confirmation: "testmiss",
  school_id: school2.id,
  type: "Partner",
  activated: true )

student1 = Student.create!( first_name: "Byron",
  last_name: "Watson",
  school_id: school1.id,
  activated: true )

student2 = Student.create!( first_name: "Lucy",
  last_name: "Pevensie",
  school_id: school4.id,
  activated: true )

student3 = Student.create!( first_name: "Veruca",
  last_name: "Salt",
  school_id: school3.id,
  activated: true )

student4 = Student.create!( first_name: "Dallas",
  last_name: "Winston",
  school_id: school2.id,
  activated: true )

student5 = Student.create!( first_name: "Frank",
  last_name: "Anderson",
  school_id: school2.id,
  activated: true )

student6 = Student.create!( first_name: "Ramona",
  last_name: "Quimby",
  school_id: school4.id,
  activated: true )

student7 = Student.create!( first_name: "Ron",
  last_name: "Howard",
  school_id: school1.id,
  activated: true )

student9 = Student.create!( first_name: "Rubeus",
  last_name: "Hagrid",
  school_id: school1.id,
  activated: true )

student10 = Student.create!( first_name: "Fern",
  last_name: "Arable",
  school_id: school3.id,
  activated: true )

student11 = Student.create!( first_name: "Harold",
  last_name: "Johnson",
  school_id: school4.id,
  activated: true )

student12 = Student.create!( first_name: "Homer",
  last_name: "Zuckerman",
  school_id: school3.id,
  activated: true )

student13 = Student.create!( first_name: "Frances",
  last_name: "Hoban",
  school_id: school4.id,
  activated: true )

Login.create(
  time_in: Time.now.midnight - 6*24*3600 + 13*3600 - 2*60,  
  time_out: Time.now.midnight - 6*24*3600 + 14*3600 + 60,  
  user_id: teacher2.id)

Lesson.create!(student_id: student3.id, 
  time_in: Time.now.midnight - 6*24*3600 + 13*3600,  
  time_out: Time.now.midnight - 6*24*3600 + 13.5*3600 - 60,  
  brought_instrument: true,
  brought_books: false,
  progress: 3, 
  behavior: 2,
  notes: "cranky",
  user_id: teacher2.id,
  school_id: school3.id)

Lesson.create!(student_id: student9.id, 
  time_in: Time.now.midnight - 6*24*3600 + 13.5*3600,  
  time_out: Time.now.midnight - 6*24*3600 + 14*3600,  
  brought_instrument: true,
  brought_books: false,
  progress: 3, 
  behavior: 2,
  notes: "surly",
  user_id: teacher2.id,
  school_id: school3.id)

Login.create(
  time_in: Time.now.midnight - 6*24*3600 + 13*3600 - 60,  
  time_out: Time.now.midnight - 6*24*3600 + 14*3600 + 2*60,  
  user_id: teacher1.id)

Lesson.create!(student_id: student4.id, 
  time_in: Time.now.midnight - 6*24*3600 + 13*3600 + 60,  
  time_out: Time.now.midnight - 6*24*3600 + 13.5*3600,  
  brought_instrument: true,
  brought_books: false,
  progress: 3, 
  behavior: 2,
  notes: "disrespectful and inattentive",
  user_id: teacher1.id,
  school_id: school2.id)

Lesson.create!(student_id: student5.id, 
  time_in: Time.now.midnight - 6*24*3600 + 13.5*3600 + 60,  
  time_out: Time.now.midnight - 6*24*3600 + 14*3600 - 60,  
  brought_instrument: true,
  brought_books: false,
  progress: 3, 
  behavior: 2,
  notes: "same as usual",
  user_id: teacher1.id,
  school_id: school2.id)

Login.create(
  time_in: Time.now.midnight - 3*24*3600 + 13*3600,  
  time_out: Time.now.midnight - 3*24*3600 + 14*3600 + 60,  
  user_id: teacher2.id)

Lesson.create!(student_id: student5.id, 
  time_in: Time.now.midnight - 3*24*3600 + 13*3600 + 2*60,  
  time_out: Time.now.midnight - 3*24*3600 + 13.5*3600,  
  brought_instrument: true,
  brought_books: false,
  progress: 3, 
  behavior: 2,
  notes: "mopey",
  user_id: teacher2.id,
  school_id: school2.id)

Lesson.create!(student_id: student4.id, 
  time_in: Time.now.midnight - 3*24*3600 + 13.5*3600 + 60,  
  time_out: Time.now.midnight - 3*24*3600 + 14*3600,  
  brought_instrument: true,
  brought_books: false,
  progress: 3, 
  behavior: 2,
  notes: "distracted",
  user_id: teacher2.id,
  school_id: school2.id)

Login.create(
  time_in: Time.now.midnight - 3*24*3600 + 13*3600,  
  time_out: Time.now.midnight - 3*24*3600 + 14*3600,  
  user_id: teacher1.id)

Lesson.create!(student_id: student3.id, 
  time_in: Time.now.midnight - 3*24*3600 + 13*3600,  
  time_out: Time.now.midnight - 3*24*3600 + 13.5*3600 - 60,  
  brought_instrument: true,
  brought_books: false,
  progress: 3, 
  behavior: 2,
  notes: "not at her best",
  user_id: teacher1.id,
  school_id: school3.id)

Lesson.create!(student_id: student9.id, 
  time_in: Time.now.midnight - 3*24*3600 + 13.5*3600,  
  time_out: Time.now.midnight - 3*24*3600 + 14*3600 - 60,  
  brought_instrument: true,
  brought_books: false,
  progress: 3, 
  behavior: 2,
  notes: "ok",
  user_id: teacher1.id,
  school_id: school3.id)

Login.create(
  time_in: Time.now.midnight - 2*24*3600 + 13*3600 + 60,  
  time_out: Time.now.midnight - 2*24*3600 + 14*3600 + 2*60,  
  user_id: teacher2.id)

Lesson.create!(student_id: student1.id, 
  time_in: Time.now.midnight - 2*24*3600 + 13*3600 + 60,  
  time_out: Time.now.midnight - 2*24*3600 + 13.5*3600 + 60,  
  brought_instrument: true,
  brought_books: true,
  progress: 5, 
  behavior: 5,
  notes: "starting new book",
  user_id: teacher2.id,
  school_id: school1.id)

Lesson.create!(student_id: student7.id, 
  time_in: Time.now.midnight - 2*24*3600 + 13.5*3600 + 2*60,  
  time_out: Time.now.midnight - 2*24*3600 + 14*3600 + 60,  
  brought_instrument: true,
  brought_books: true,
  progress: 5, 
  behavior: 5,
  notes: "great!",
  user_id: teacher2.id,
  school_id: school1.id)

Login.create(
  time_in: Time.now.midnight - 2*24*3600 + 13*3600 - 60,  
  time_out: Time.now.midnight - 2*24*3600 + 14*3600 + 60,  
  user_id: teacher1.id)

Lesson.create!(student_id: student2.id, 
  time_in: Time.now.midnight - 2*24*3600 + 13*3600 - 60,  
  time_out: Time.now.midnight - 2*24*3600 + 13.5*3600,  
  brought_instrument: true,
  brought_books: true,
  progress: 3, 
  behavior: 4,
  notes: "sleepy",
  user_id: teacher1.id,
  school_id: school4.id)

Lesson.create!(student_id: student12.id, 
  time_in: Time.now.midnight - 2*24*3600 + 13.5*3600,  
  time_out: Time.now.midnight - 2*24*3600 + 14*3600 + 60,  
  brought_instrument: true,
  brought_books: true,
  progress: 3, 
  behavior: 4,
  notes: "broke a string",
  user_id: teacher1.id,
  school_id: school4.id)

Login.create(
  time_in: Time.now.midnight - 24*3600 + 13*3600,  
  time_out: Time.now.midnight - 24*3600 + 14*3600 + 60,  
  user_id: teacher2.id)

Lesson.create!(student_id: student4.id, 
  time_in: Time.now.midnight - 24*3600 + 13*3600 + 60,  
  time_out: Time.now.midnight - 24*3600 + 13.5*3600 - 60,  
  brought_instrument: true,
  brought_books: true,
  progress: 3, 
  behavior: 4,
  notes: "doing better",
  user_id: teacher2.id,
  school_id: school2.id)

Lesson.create!(student_id: student5.id, 
  time_in: Time.now.midnight - 24*3600 + 13.5*3600,  
  time_out: Time.now.midnight - 24*3600 + 14*3600,  
  brought_instrument: true,
  brought_books: false,
  progress: 5, 
  behavior: 2,
  notes: "fine",
  user_id: teacher2.id,
  school_id: school2.id)

Login.create(
  time_in: Time.now - 6*60, # six minutes before db:seed
  user_id: teacher2.id)

Lesson.create!(student_id: student10.id, 
  time_in: Time.now - 5*60,
  brought_instrument: true,
  brought_books: true,
  user_id: teacher2.id,
  school_id: school3.id)

Login.create(
  time_in: Time.now.midnight + 13*3600,  
  user_id: teacher1.id)

Lesson.create!(student_id: student6.id, 
  time_in: Time.now.midnight + 13*3600,  
  time_out: Time.now.midnight + 13.5*3600,  
  brought_instrument: true,
  brought_books: true,
  progress: 6, 
  behavior: 5,
  notes: "very motivated",
  user_id: teacher1.id,
  school_id: school4.id)

Lesson.create!(student_id: student11.id, 
  time_in: Time.now.midnight + 13.5*3600,  
  brought_instrument: true,
  brought_books: true,
  user_id: teacher1.id,
  school_id: school4.id)

Login.create(
  time_in: Time.now - 7*60,
  user_id: teacher3.id)

Login.create(
  time_in: Time.now - 5*60,
  user_id: teacher4.id)


