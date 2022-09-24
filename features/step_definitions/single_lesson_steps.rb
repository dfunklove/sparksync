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
  @registered_user = FactoryBot.create(:teacher,
    email: "test@example.com",
    password: "sparksISgr8*",
    first_name: "Test",
    last_name: "Teacher")
  end

Given('I am logged in') do
  visit root_path
  fill_in "session_email", with: "test@example.com"
  fill_in "session_password", with: "sparksISgr8*"
  click_button "Log in"
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

When('I enter a student name') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I select a school') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I click Start Lesson') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I am prompted to confirm creation of the student') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I select a school') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I click Start Lesson') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I click No on the create student confirmation dialog') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I click Yes on the create student confirmation dialog') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I am at the Single Lesson Checkout page') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('The student is in the database') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('A lesson with the student is in the database') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('The start time of the lesson is accurate') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I click Yes on the create student confirmation dialog') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I am at the Single Lesson Checkout page') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I click Finish Lesson') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('The end time of the lesson is accurate') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I have the option to teach a lesson to that student') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I have taught {int} students') do |int|
# Given('I have taught {float} students') do |float|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I have the option to teach a lesson to any of the students') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I have not taught the student') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('The student is not listed') do
  pending # Write code here that turns the phrase above into concrete actions
end
