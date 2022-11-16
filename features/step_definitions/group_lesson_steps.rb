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
  expect(page).to have_current_path(group_lessons_checkout_path, wait: 10)
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

When('I select {int} students for the group lesson') do |int|
  checkboxes = all('.student_select')
  int.times do |i|
    checkboxes[i].set(true)
  end
end

When('I click Add Student') do
  click_on("Add Student")
end

When('I click Start Lesson') do
  click_on("Start Lesson")
end

When('I click Add Student and I click No on the confirmation dialog') do
  dismiss_confirm do
    click_on("Add Student")
  end
end

When('I click Add Student and I click Yes on the confirmation dialog') do
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
  @lesson = GroupLesson.last
  expect @lesson.lessons.length == int
end

Then('A group lesson with my first {int} students is in the database') do |int|
  @lesson = GroupLesson.last
  lessons = @lesson.lessons
  int.times do |i|
    lessons[i].student.first_name == "Test#{i+1}"
  end
end

Then('I have the option to teach a group lesson to {int} students') do |int|
  assert_selector(:css, ".existing_student_row", count: int)
end

Then('No students are listed in group lesson') do
  expect(page).to have_no_css(".existing_student_row")
end

Then('The first student appears on the page') do
  assert_selector("td.first_name", text: "Test1")
end

Then('The second student appears on the page') do
  assert_selector("td.first_name", text: "Test2")
end

Given('I enter the other student name {int}') do |int|
  fill_in("new_student_first_name", with: "Other#{int}")
  fill_in("new_student_last_name", with: "Student")
end

Given('I select school {int}') do |int|
  select("Test#{int}", from: "new_student_school_id")
end
