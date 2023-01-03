When('I go to the courses page') do
  visit courses_path
end

When('I have a course') do
  expect(page).to have_css(".courses")
end

When('I have no courses') do
  expect(page).to have_no_css(".courses")
end

Then('I see the message for no courses') do
  expect(page).to have_css(".courses_empty_message")
end

When('I click Teach this session') do
  click_on('Teach this session')
end

Then('I am at the Attendance page') do
  expect(page).to have_text("Attendance")
end

When('I expand the group lesson record') do
  click_button('+')
end

When('There are {int} students in the list') do |int|
  assert_selector(:css, ".existing_student_row", count: int)
end

When('There are {int} students in the group lesson record') do |int|
  assert_selector(:css, ".group-lesson-row", count: (int + 1))
end

When('I mark {int} students as not present') do |int|
  checkboxes = all('.student_select')
  int.times do |i|
    checkboxes[i].set(false)
  end
end

Then('The test course is in the list') do
  expect(page).to have_text("#{Course.model_name.human}: TestCourse1")
end

Then('The students from the test courses are in the list') do
  expect(page).to have_text("TestStudent1")
  expect(page).to have_text("TestStudent2")
  expect(page).to have_text("TestStudent3")
end