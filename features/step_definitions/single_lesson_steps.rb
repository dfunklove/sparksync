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

Then('I see a link to the Start Single Lesson page') do
  find_link "Single Lesson"
end

When('I click the link to the Start Single Lesson page') do
  click_link "Single Lesson"
end

When('I go to the Start Single Lesson page') do
  visit new_lesson_path
end

Then('I am at the Start Single Lesson page') do
  expect(page).to have_current_path(new_lesson_path)
end

Given('I have not taught any lessons') do
  @registered_user.lessons.length == 0
end

Given('The student is not in the database') do
  expect !Student.where(first_name: "Test1", last_name: "Student", school_id: 1).exists?
end

# TODO: find the form first

When('I enter a student name') do
  form = find("#add_student_form")
  form.fill_in("lesson[student_attributes][first_name]", with: "Test1")
  form.fill_in("lesson[student_attributes][last_name]", with: "Student")
end

When('I select a school') do
  form = find("#add_student_form")
  form.select("Test1", from: "lesson[student_attributes][school_id]")
end

When('I click Start Lesson') do
  form = find("#add_student_form")
  dismiss_confirm do
    form.click_on("Start Lesson")
  end
end

Then('I am prompted to confirm creation of the student') do
  form = find("#add_student_form")
  dismiss_confirm do
    form.click_on("Start Lesson")
  end
end

When('I click No on the create student confirmation dialog') do
  form = find("#add_student_form")
  dismiss_confirm do
    form.click_on("Start Lesson")
  end
end

When('I click Yes on the create student confirmation dialog') do
  form = find("#add_student_form")
  accept_confirm do
    form.click_on("Start Lesson")
  end
end

Then('I am at the Single Lesson Checkout page') do
  expect(page).to have_current_path(lessons_checkout_path)
end

#TODO use the UI to test these
Then('The student is in the database') do
  @student = Student.where(first_name: "Test1", last_name: "Student", school_id: 1).first
  expect @student
end

Then('A lesson with the student is in the database') do
  @student = Student.where(first_name: "Test1", last_name: "Student", school_id: 1).first
  @lesson = Lesson.where(student_id: @student.id, user_id: @registered_user.id).first
  expect @lesson
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
    click_on "Finish Lesson"
  end
end

Then('I have the option to teach a lesson to {int} students') do |int|
  assert_selector(:button, "Start Lesson", count: int + 1)
end

Then('No students are listed') do
  assert_selector(:button, "Start Lesson", count: 1)
end
