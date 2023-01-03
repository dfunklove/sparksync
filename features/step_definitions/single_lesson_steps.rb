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

Given('The student is not in the database') do
  expect !Student.where(first_name: "TestStudent1", last_name: "Student", school_id: 1).exists?
end

# TODO: find the form first

When('I enter a student name') do
  form = find("#add_student_form")
  form.fill_in("lesson[student_attributes][first_name]", with: "TestStudent1")
  form.fill_in("lesson[student_attributes][last_name]", with: "Student")
end

When('I select a school from the add student form') do
  form = find("#add_student_form")
  form.select("TestSchool1", from: "lesson[student_attributes][school_id]")
end

When('I click Start Lesson on the add student form') do
  form = find("#add_student_form")
  form.click_on("Start Lesson")
end

Then('I am prompted to confirm creation of the student before starting the lesson') do
  form = find("#add_student_form")
  dismiss_confirm do
    form.click_on("Start Lesson")
  end
end

When('I click No on the create student confirmation dialog before starting the lesson') do
  form = find("#add_student_form")
  dismiss_confirm do
    form.click_on("Start Lesson")
  end
end

When('I click Yes on the create student confirmation dialog before starting the lesson') do
  form = find("#add_student_form")
  accept_confirm do
    form.click_on("Start Lesson")
  end
end

When('I enter a note') do
  fill_in "lesson_notes", with: "test note"
end

Then('I am at the Single Lesson Checkout page') do
  expect(page).to have_current_path(lessons_checkout_path)
end

#TODO use the UI to test these
Then('I see the lesson I created') do
  tr = find_field("lesson_notes", with: "test note").find(:xpath, "../..")
  expect(tr).to have_text("TestStudent1")
  expect(tr).to have_text("TestSchool1")
  expect(tr).to have_text("TestTeacher1")
end

Then('I have the option to teach a single lesson to {int} students') do |int|
  assert_selector(:button, "Start Lesson", count: int + 1)
end

Then('No students are listed on the Start Single Lesson page') do
  assert_selector(:button, "Start Lesson", count: 1)
end
