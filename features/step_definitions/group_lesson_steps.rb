Then('I see a link to the Start Group Lesson page') do
  find_link "Group Lesson"
end

When('I click the link to the Start Group Lesson page') do
  click_link "Group Lesson"
end

When('I go to the Start Group Lesson page') do
  visit new_group_lesson_path
end

Then('I am at the Start Group Lesson page') do
  expect(page).to have_current_path(new_group_lesson_path)
end

Then('I am at the Group Lesson Checkout page') do
  expect(page).to have_current_path(group_lessons_checkout_path, wait: 5)
end

When('I enter the first student name') do
  fill_in("new_student_first_name", with: "Test1")
  fill_in("new_student_last_name", with: "Student")
end

When('I enter the second student name') do
  fill_in("new_student_first_name", with: "Test2")
  fill_in("new_student_last_name", with: "Student")
end

When('I select a school') do
  select("Test1", from: "new_student_school_id")
end

When('I click Add Student') do
  dismiss_confirm do
    click_on("Add Student")
  end
end

When('I click Start Lesson') do
  click_on("Start Lesson")
end

Then('I am prompted to confirm creation of the student') do
  dismiss_confirm do
    click_on("Add Student")
  end
end

When('I click No on the create student confirmation dialog') do
  dismiss_confirm do
    click_on("Add Student")
  end
end

When('I click Yes on the create student confirmation dialog') do
  accept_confirm do
    click_on("Add Student")
  end
end

#TODO use the UI to test these
Given('The first student is not in the database') do
  expect !Student.where(first_name: "Test1", last_name: "Student", school_id: 1).exists?
end

Given('The second student is not in the database') do
  expect !Student.where(first_name: "Test2", last_name: "Student", school_id: 1).exists?
end

Then('The first student is in the database') do
  @student = Student.where(first_name: "Test1", last_name: "Student", school_id: 1).first
  expect @student
end

Then('The second student is in the database') do
  @student = Student.where(first_name: "Test2", last_name: "Student", school_id: 1).first
  expect @student
end

Then('A group lesson with {int} students is in the database') do |int|
  @student = Student.where(first_name: "Test1", last_name: "Student", school_id: 1).first
  @lesson1 = Lesson.where(student_id: @student.id, user_id: @registered_user.id).first
  expect @lesson1
  @student = Student.where(first_name: "Test2", last_name: "Student", school_id: 1).first
  @lesson2 = Lesson.where(student_id: @student.id, user_id: @registered_user.id).first
  expect @lesson2
  expect @lesson1.group_lesson_id == @lesson2.group_lesson_id
  @lesson = GroupLesson.find(@lesson1.group_lesson_id) # this variable is used by other steps
end

Then('I have the option to teach a group lesson to {int} students') do |int|
  assert_selector(:css, ".existing_student_row", count: int)
end

Then('No students are listed in group lesson') do
  expect(page).to have_no_css(".existing_student_row")
end

Then('The first student appears on the page') do
  assert_selector("td", text: "Test1")
end