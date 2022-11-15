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
  assert_selector(:button, "New Course")
end

When('I visit the homepage') do
  visit root_path
end

Given('I have not taught any lessons') do
  @registered_user.lessons.length == 0
end

Then('The start time of the lesson is accurate') do
  expect Time.now - @lesson.time_in < 5.seconds
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
    form.fill_in("lesson[student_attributes][first_name]", with: "Test#{i}")
    form.fill_in("lesson[student_attributes][last_name]", with: "Student")
    form.select("Test1", from: "lesson[student_attributes][school_id]")
    accept_confirm do
      form.click_on("Start Lesson")
    end
    click_on "Finish Lesson", wait: 5
  end
end
