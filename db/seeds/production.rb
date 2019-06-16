admin1 = Admin.create!(  first_name: "Cynthia",
  last_name: "Smith",
  email: "cynthia@sparksforsuccess.org",
  password: "musicisthebest",
  password_confirmation: "musicisthebest",
  type: "Admin",
  activated: true )

admin2 = Admin.create!(  first_name: "Chris",
  last_name: "Smith",
  email: "chris.smith@pelotonu.org",
  password: "sparksISgr8*",
  password_confirmation: "sparksISgr8*",
  type: "Admin",
  activated: true )

school1 = School.create!( name: "Blackshear", activated: true)
school2 = School.create!( name: "Kealing", activated: true)
school3 = School.create!( name: "Oak Springs", activated: true)
school4 = School.create!( name: "Zavala", activated: true)
