def find_row_with_string(query)
  tr = page.find(:xpath, ".//tr[.//input[@value='#{query}']]")
end

Given('Testing admins exist') do
  FactoryBot.create(:admin,
    first_name: "Driver",
    last_name: "Admin",
    email: "driver@example.com",
    password: "Letters1!")
  FactoryBot.create(:admin,
    first_name: "TestAdmin1",
    last_name: "Admin",
    email: "test_admin1@example.com",
    password: "Letters1!")
end

Given('Testing goals exist') do
  FactoryBot.create(:goal,
    name: "TestGoal1")
  FactoryBot.create(:goal,
    name: "TestGoal2")
  FactoryBot.create(:goal,
    name: "TestGoal3")
end

Given('Testing schools exist') do
  FactoryBot.create(:school,
    name: "TestSchool1",
    id: 101)
  FactoryBot.create(:school,
    name: "TestSchool2",
    id: 102)
  FactoryBot.create(:school,
    name: "TestSchool3",
    id: 103)
  FactoryBot.create(:school,
    name: "Test_NoStudents",
    id: 104)
end

Given('Testing students exist') do
  FactoryBot.create(:student,
    first_name: "TestStudent1",
    last_name: "Student",
    school_id: 101,
    id: 101)
  FactoryBot.create(:student,
    first_name: "TestStudent2",
    last_name: "Student",
    school_id: 101,
    id: 102)
  FactoryBot.create(:student,
    first_name: "TestStudent3",
    last_name: "Student",
    school_id: 101,
    id: 103)
  FactoryBot.create(:student,
    first_name: "TestStudent4",
    last_name: "Student",
    school_id: 102,
    id: 104)
  FactoryBot.create(:student,
    first_name: "TestStudent5",
    last_name: "Student",
    school_id: 102,
    id: 105)
  FactoryBot.create(:student,
    first_name: "TestStudent6",
    last_name: "Student",
    school_id: 102,
    id: 106)
end

Given('Other students exist') do
  FactoryBot.create(:student,
    first_name: "Other1",
    last_name: "Student",
    school_id: 101)
  FactoryBot.create(:student,
    first_name: "Other2",
    last_name: "Student",
    school_id: 102)
  FactoryBot.create(:student,
    first_name: "Other3",
    last_name: "Student",
    school_id: 103)
end

Given('Testing partners exist') do
  FactoryBot.create(:partner,
    email: "test_partner1@example.com",
    password: "Letters1!",
    first_name: "TestPartner1",
    last_name: "Partner",
    school_id: 101)
end

Given('Testing teachers exist') do
  FactoryBot.create(:teacher,
    email: "test_teacher1@example.com",
    password: "Letters1!",
    first_name: "TestTeacher1",
    last_name: "Teacher",
    id: 101)
  FactoryBot.create(:teacher,
    email: "test_teacher2@example.com",
    password: "Letters1!",
    first_name: "TestTeacher2",
    last_name: "Teacher",
    id: 102)
end

Given('Testing courses exist') do
  FactoryBot.create(:course,
    name: "TestCourse1",
    id: 101,
    school_id: 101,
    user_id: 101,
    start_date: '2023-01-01',
    student_ids: [101,102,103])
end

# do not use teacher 1 or student 1 because this will prevent them being deleted
Given('Testing lessons exist') do
  FactoryBot.create(:lesson,
    school_id: 101,
    user_id: 102,
    student_id: 103,
    time_in: "2023-01-01 1:00",
    time_out: "2023-01-01 2:00",
    notes: "TestLesson1"
  )
end

Given('I am logged in as an admin') do
  visit root_path
  fill_in "session_email", with: "driver@example.com"
  fill_in "session_password", with: "Letters1!"
  click_button "Log in"
  assert_selector(:link, "Logout")
end

Given('I am logged in as a teacher') do
  visit root_path
  fill_in "session_email", with: "test_teacher1@example.com"
  fill_in "session_password", with: "Letters1!"
  click_button "Log in"
  assert_selector(:link, "Logout")
end

Given('I click Logout') do
  click_on("Logout")
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

When(/I go to the page for model (\S+)/) do |model_name|
  visit "/#{model_name}s"
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
    form.fill_in("lesson[student_attributes][first_name]", with: "TestStudent#{i+1}")
    form.fill_in("lesson[student_attributes][last_name]", with: "Student")
    form.select("TestSchool1", from: "lesson[student_attributes][school_id]")
    form.click_on("Start Lesson")
    click_on "Finish Lesson", wait: 5
  end
end

When('I click the Active button') do
  click_button('Active')
end

When('I click the All button') do
  click_button('All')
end

When('I click the Inactive button') do
  click_button('Inactive')
end

Then('I should see the Active button') do
  expect(page).to have_button('Active')
end

Then('I should see the All button') do
  expect(page).to have_button('All')
end

Then('I should see the Inactive button') do
  expect(page).to have_button('Inactive')
end