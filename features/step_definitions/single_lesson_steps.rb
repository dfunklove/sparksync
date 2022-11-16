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
  expect !Student.where(first_name: "Test1", last_name: "Student", school_id: 1).exists?
end

# TODO: find the form first

When('I enter a student name') do
  form = find("#add_student_form")
  form.fill_in("lesson[student_attributes][first_name]", with: "Test1")
  form.fill_in("lesson[student_attributes][last_name]", with: "Student")
end

When('I select a school from the add student form') do
  form = find("#add_student_form")
  form.select("Test1", from: "lesson[student_attributes][school_id]")
end

When('I click Start Lesson on the add student form') do
  form = find("#add_student_form")
  dismiss_confirm do
    form.click_on("Start Lesson")
  end
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
Then('The student is in the database') do
  @student = Student.where(first_name: "Test1", last_name: "Student", school_id: 1).first
  expect @student
end

Then('A lesson with the student is in the database') do
  @student = Student.where(first_name: "Test1", last_name: "Student", school_id: 1).first
  @lesson = Lesson.where(student_id: @student.id, user_id: @registered_user.id).first
  expect @lesson
end

Then('The lesson contains my note') do
  expect @lesson.notes == "test note"
end

Then('I have the option to teach a single lesson to {int} students') do |int|
  assert_selector(:button, "Start Lesson", count: int + 1)
end

Then('No students are listed on the Start Single Lesson page') do
  assert_selector(:button, "Start Lesson", count: 1)
end
