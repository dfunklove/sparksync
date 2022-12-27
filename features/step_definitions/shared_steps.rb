Given('Testing schools exist') do
  FactoryBot.create(:school,
    name: "Test1",
    id: 1)
    FactoryBot.create(:school,
      name: "Test2",
      id: 2)
    FactoryBot.create(:school,
    name: "Test3",
    id: 3)
end

Given('Testing students exist') do
  FactoryBot.create(:student,
    first_name: "Test1",
    last_name: "Student",
    school_id: 1)
  FactoryBot.create(:student,
    first_name: "Test2",
    last_name: "Student",
    school_id: 1)
    FactoryBot.create(:student,
      first_name: "Test3",
      last_name: "Student",
      school_id: 1)
  end

Given('Other students exist') do
  FactoryBot.create(:student,
    first_name: "Other1",
    last_name: "Student",
    school_id: 1)
  FactoryBot.create(:student,
    first_name: "Other2",
    last_name: "Student",
    school_id: 2)
  FactoryBot.create(:student,
    first_name: "Other3",
    last_name: "Student",
    school_id: 3)
end

Given('I am registered as a teacher') do
  @registered_user = Teacher.where(email: "test@example.com").first || FactoryBot.create(:teacher,
    email: "test@example.com",
    password: "sparksISgr8*",
    first_name: "Test",
    last_name: "Teacher")
  end

Given('I am logged in') do
  visit root_path
  fill_in "session_email", with: @registered_user.email
  fill_in "session_password", with: @registered_user.password
  click_button "Log in"
  assert_selector(:link, "Logout")
end

When('I visit the homepage') do
  visit root_path
end

When('I go to My Records') do
  visit '/lessons'
end

When('I go to My Students') do
  visit '/students'
end

Given('I have not taught any lessons') do
  @registered_user.lessons.length == 0
end

Then('The start time of the lesson is accurate') do
  expect Time.now - @lesson.time_in < 5.seconds
end

When('I click Add Student') do
  click_on("Add Student")
end

When('I click Start Lesson') do
  click_on("Start Lesson")
end

When('I click Finish Lesson') do
  click_on "Finish Lesson"
end

Then('The end time of the lesson is accurate') do
  expect Time.now - @lesson.time_out < 5.seconds
end

Given('I have taught {int} students') do |int|
  int.times do |i|
    click_link "Single Lesson"
    form = find("#add_student_form")
    form.fill_in("lesson[student_attributes][first_name]", with: "Test#{i+1}")
    form.fill_in("lesson[student_attributes][last_name]", with: "Student")
    form.select("Test1", from: "lesson[student_attributes][school_id]")
    form.click_on("Start Lesson")
    click_on "Finish Lesson", wait: 5
  end
end
