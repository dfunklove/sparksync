admin_email = "test_admin1@example.com"
admin_first_name = "TestAdmin1"
admin_last_name = "Admin"
new_admin_email = "imadethis@example.com"

Given('I go to Admins') do
  visit '/admins'
end

When('I click Send') do
  click_button('Send')
end

Then('I should be asked to enter a first name, last name, and email') do
  expect(page).to have_text("First name can't be blank")
  expect(page).to have_text("Last name can't be blank")
  expect(page).to have_text("Email can't be blank")
end

When('I enter a first name, last name, and invalid email for a new admin') do
  tr = find("tr.new_record")
  tr.fill_in("admin_first_name", with: "MyTest1")
  tr.fill_in("admin_last_name", with: "MyTest1")
  tr.fill_in("admin_email", with: "i@e")
end

Then('I should be asked to enter a valid email') do
  expect(page).to have_text("Email is invalid")
end

When('I enter a first name, last name, and valid email for a new admin') do
  tr = find("tr.new_record")
  tr.fill_in("admin_first_name", with: "MyTest1")
  tr.fill_in("admin_last_name", with: "MyTest1")
  tr.fill_in("admin_email", with: "imadethis@example.com")
end

When('I enter a new first name, last name, and email for the admin') do
  tr = find_row_with_string(admin_email)
  tr.fill_in("admin_first_name", with: "UpdatedFirst")
  tr.fill_in("admin_last_name", with: "UpdatedLast")
  tr.fill_in("admin_email", with: "updated@example.com")  
end

Then('I should see the new admin') do
  tr = find_row_with_string(admin_email)
  expect(tr).to have_button("Reset")
end

Then('I should see the updated admin') do
  tr = find_row_with_string("updated@example.com")
  expect(tr.find('#admin_first_name')).to have_attributes(value: "UpdatedFirst")
  #expect(tr.find('#admin_last_name')).to have_value("UpdatedLast")
end

When('I click Reset on the admin') do
  tr = find_row_with_string(admin_email)
  tr.find_button('Reset').click
end

When('I click Modify on the admin') do
  tr = find_row_with_string(admin_email)
  tr.find_button('Modify').click
end

When(/I click Activate on record (\S+)/) do |record_id|
  tr = find_row_with_string(record_id)
  tr.find_button('Activate').click
end

When(/I click Deactivate on record (\S+)/) do |record_id|
  tr = find_row_with_string(record_id)
  tr.find_button('Deactivate').click
end

When(/I click Delete on record (\S+) and dismiss the popup/) do |record_id|
  tr = find_row_with_string(record_id)
  dismiss_confirm do
    tr.find_button('Delete').click
  end
end

When(/I click Delete on record (\S+) and confirm the popup/) do |record_id|
  tr = find_row_with_string(record_id)
  accept_confirm do
    tr.find_button('Delete').click
  end
end

Then(/I should see an Activate button for record (\S+)/) do |record_id|
  tr = find_row_with_string(record_id)
  expect(tr).to have_button("Activate")
end

Then(/I should see a Deactivate button for record (\S+)/) do |record_id|
  tr = find_row_with_string(record_id)
  expect(tr).to have_button("Deactivate")
end

Then(/I should see a Delete button for record (\S+)/) do |record_id|
  tr = find_row_with_string(record_id)
  expect(tr).to have_button("Delete")
end

Then(/I should not see record (\S+)/) do |record_id|
  expect(page).to have_no_xpath(".//tr[.//input[@value='#{record_id}']]")
end

Then('I should be informed that a welcome email was sent') do
  expect(page).to have_text("A welcome email was sent")
end

Then('I should be informed that a password reset email was sent to the admin') do
  expect(page).to have_text("A password reset email was sent to #{admin_email}")
end

Then('I should be informed that the record was modified') do
  expect(page).to have_text("was modified")
end

Then('I should be informed that the record was activated') do
  expect(page).to have_text(/(was|have been) activated/)
end

Then('I should be informed that the record was deactivated') do
  expect(page).to have_text(/(was|have been) deactivated/)
end

Then('I should be informed that the record was deleted') do
  expect(page).to have_text("was deleted")
end

When('I click New Session') do
  click_button("New Session")
end

When('I click Create Session') do
  click_button("Create Session")
end

When('I should be asked to enter a name, teacher, school, and students') do
  expect(page).to have_text("Name can't be blank")
  expect(page).to have_text("School can't be blank")
  expect(page).to have_text("Teacher can't be blank")
  expect(page).to have_text(/Please select \S+ or more students/)
end

When('I fill in the info for the course') do
  fill_in("course_name", with: "MyTestCourse1")
  select("TestSchool1", from: "course_school_id")
  select("TestTeacher1", from: "course_user_id")
  check("course_student_ids_101")
  check("course_student_ids_102")
end

When('I should see the new course in the list') do
  expect(page).to have_text("MyTestCourse1")
end

When('I click Edit on the new course') do
  find(".td", text: "MyTestCourse1").find(:xpath, "..").find_button("Edit").click
end

When('I should see the course info I entered') do
  expect(page).to have_field("course_name", with: "MyTestCourse1")
  expect(page).to have_select("course_school_id", selected: "TestSchool1")
  expect(page).to have_select("course_user_id", selected: "TestTeacher1 Teacher")
  expect(page).to have_checked_field("TestStudent1 Student")
  expect(page).to have_checked_field("TestStudent2 Student")
end

When('I go to the partners page') do
  visit('/partners')
end

When('I should be asked to enter a school, first name, last name, and email') do
  expect(page).to have_text("School can't be blank")
  expect(page).to have_text("First name can't be blank")
  expect(page).to have_text("Last name can't be blank")
  expect(page).to have_text("Email can't be blank")
end

When('I enter a school, first name, last name, and invalid email for a new partner') do
  tr = find("tr.new_record")
  tr.select("TestSchool1", from: "partner_school_id")
  tr.fill_in("partner_first_name", with: "MyTestPartner1")
  tr.fill_in("partner_last_name", with: "Partner")
  tr.fill_in("partner_email", with: "MyTestPartner1@example")
end

When('I enter a school, first name, last name, and valid email for a new partner') do
  tr = find("tr.new_record")
  tr.select("TestSchool1", from: "partner_school_id")
  tr.fill_in("partner_first_name", with: "MyTestPartner1")
  tr.fill_in("partner_last_name", with: "Partner")
  tr.fill_in("partner_email", with: "MyTestPartner1@example.com")
end

When('I should see the new partner') do
  tr = find_field("partner_first_name", with: "MyTestPartner1").find(:xpath, "../..")
  expect(tr).to have_button("Deactivate")
  expect(tr).to have_field("partner_last_name", with: "Partner")
  expect(tr).to have_field("partner_email", with: "mytestpartner1@example.com")
end

When('I go to the schools page') do
  visit '/schools'
end

When('I click Create') do
  click_on('Create')
end

When('I should be asked to enter a name') do
  expect(page).to have_text("Name can't be blank")
end

When('I enter a name for a new school') do
  tr = find("tr.new_record")
  tr.fill_in("school_name", with: "MyTestSchool1")
end

When('I should be informed that a new school was created') do
  expect(page).to have_text("New school MyTestSchool1 was created")
end

When('I should see the new school') do
  tr = find_field("school_name", with: "MyTestSchool1").find(:xpath, "../..")
  expect(tr).to have_button("Deactivate")
end

When('I go to the students page') do
  visit '/students'
end

When('I should be asked to enter a first name, last name, and school') do
  expect(page).to have_text("School can't be blank")
  expect(page).to have_text("First name can't be blank")
  expect(page).to have_text("Last name can't be blank")
end

When('I enter a first name, last name, and school for a new student') do
  tr = find("tr.new_record")
  tr.select("TestSchool1", from: "student_school_id")
  tr.fill_in("student_first_name", with: "MyTestStudent1")
  tr.fill_in("student_last_name", with: "Student")
end

When('I should be informed that a new student was created') do
  expect(page).to have_text("New student MyTestStudent1 Student was created")
end

When('I should see the new student') do
  tr = find_field("student_first_name", with: "MyTestStudent1").find(:xpath, "../..")
  expect(tr).to have_button("Deactivate")
end

When('I go to the teachers page') do
  visit '/teachers'
end

When('I enter a first name, last name, and invalid email for a new teacher') do
  tr = find("tr.new_record")
  tr.fill_in("teacher_first_name", with: "MyTestTeacher1")
  tr.fill_in("teacher_last_name", with: "Teacher")
  tr.fill_in("teacher_email", with: "mytestteacher1@example")
end

When('I enter a first name, last name, and valid email for a new teacher') do
  tr = find("tr.new_record")
  tr.fill_in("teacher_first_name", with: "MyTestTeacher1")
  tr.fill_in("teacher_last_name", with: "Teacher")
  tr.fill_in("teacher_email", with: "mytestteacher1@example.com")
end

When('I should see the new teacher') do
  tr = find_field("teacher_first_name", with: "MyTestTeacher1").find(:xpath, "../..")
  expect(tr).to have_button("Deactivate")
end

When('I fill in new info for the course') do
  fill_in("course_name", with: "UpdatedCourse1")
  select("TestSchool2", from: "course_school_id")
  select("TestTeacher2", from: "course_user_id")
  check("course_student_ids_104")
  check("course_student_ids_105")
end

When('I click Update Session') do
  click_button("Update Session")
end

When('I click Edit on the updated course') do
  find(".td", text: "UpdatedCourse1").find(:xpath, "..").find_button("Edit").click
end

When('I should see the new course info I entered') do
  expect(page).to have_field("course_name", with: "UpdatedCourse1")
  expect(page).to have_select("course_school_id", selected: "TestSchool2")
  expect(page).to have_select("course_user_id", selected: "TestTeacher2 Teacher")
  expect(page).to have_checked_field("TestStudent4 Student")
  expect(page).to have_checked_field("TestStudent5 Student")
end

When('I enter a new school, first name, last name, and valid email for a partner') do
  tr = find_field("partner_first_name", with: "TestPartner1").find(:xpath, "../..")
  tr.select("TestSchool2", from: "partner_school_id")
  tr.fill_in("partner_first_name", with: "UpdatedPartner1")
  tr.fill_in("partner_last_name", with: "Partnerz")
  tr.fill_in("partner_email", with: "updatedpartner1@example.com")
end

When('I click Modify on the updated partner') do
  tr = find_field("partner_first_name", with: "UpdatedPartner1").find(:xpath, "../..")
  tr.click_button("Modify")
end

When('I should see the updated partner') do
  tr = find_field("partner_first_name", with: "UpdatedPartner1").find(:xpath, "../..")
  expect(tr).to have_button("Deactivate")
  expect(tr).to have_select("partner_school_id", selected: "TestSchool2")
  expect(tr).to have_field("partner_first_name", with: "UpdatedPartner1")
  expect(tr).to have_field("partner_last_name", with: "Partnerz")
  expect(tr).to have_field("partner_email", with: "updatedpartner1@example.com")
end

When('I enter a new name for a school') do
  find_field("school_name", with: "TestSchool1").fill_in(with: "UpdatedSchool1")
end

When('I click Modify on the updated school') do
  tr = find_field("school_name", with: "UpdatedSchool1").find(:xpath, "../..")
  tr.click_button("Modify")
end

When('I should see the updated school') do
  tr = find_field("school_name", with: "UpdatedSchool1").find(:xpath, "../..")
  expect(tr).to have_button("Deactivate")
end

When('I enter a new first name, last name, and school for a student') do
  tr = find_field("student_first_name", with: "TestStudent1").find(:xpath, "../..")
  tr.select("TestSchool2", from: "student_school_id")
  tr.fill_in("student_first_name", with: "UpdatedStudent1")
  tr.fill_in("student_last_name", with: "Studentz")
end

When('I click Modify on the updated student') do
  tr = find_field("student_first_name", with: "UpdatedStudent1").find(:xpath, "../..")
  tr.click_button("Modify")
end

When('I should see the updated student') do
  tr = find_field("student_first_name", with: "UpdatedStudent1").find(:xpath, "../..")
  expect(tr).to have_button("Deactivate")
  expect(tr).to have_select("student_school_id", selected: "TestSchool2")
  expect(tr).to have_field("student_first_name", with: "UpdatedStudent1")
  expect(tr).to have_field("student_last_name", with: "Studentz")
end

When('I enter a new first name, last name, and email for a teacher') do
  tr = find_field("teacher_first_name", with: "TestTeacher1").find(:xpath, "../..")
  tr.fill_in("teacher_first_name", with: "UpdatedTeacher1")
  tr.fill_in("teacher_last_name", with: "Teacherz")
  tr.fill_in("teacher_email", with: "updatedteacher1@example.com")
end

When('I click Modify on the updated teacher') do
  tr = find_field("teacher_first_name", with: "UpdatedTeacher1").find(:xpath, "../..")
  tr.click_button("Modify")
end

When('I should see the updated teacher') do
  tr = find_field("teacher_first_name", with: "UpdatedTeacher1").find(:xpath, "../..")
  expect(tr).to have_button("Deactivate")
  expect(tr).to have_field("teacher_first_name", with: "UpdatedTeacher1")
  expect(tr).to have_field("teacher_last_name", with: "Teacherz")
  expect(tr).to have_field("teacher_email", with: "updatedteacher1@example.com")
end

When('I click Activate on a school') do
  tr = find_field("school_name", with: "TestSchool1").find(:xpath, "../..")
  tr.click_button("Activate")
end

When('I click Deactivate on a school') do
  tr = find_field("school_name", with: "TestSchool1").find(:xpath, "../..")
  tr.click_button("Deactivate")
end

When('I should not see any students from that school') do
  expect(page).to have_no_select("#student_school_id", selected: "TestSchool1")
end

When('I click Clone on a course') do
  find(".td", text: "TestCourse1").find(:xpath, "..").find_button("Clone").click
end

When('I should see a copy of the course') do
  expect(page).to have_text("TestCourse1 (1)")
end

When('I click Edit on the copy of the course') do
  find(".td", text: "TestCourse1 (1)").find(:xpath, "..").find_button("Edit").click
end

When('I should see the cloned course info') do
  expect(page).to have_field("course_name", with: "TestCourse1 (1)")
  expect(page).to have_select("course_school_id", selected: "TestSchool1")
  expect(page).to have_select("course_user_id", selected: "TestTeacher1 Teacher")
  expect(page).to have_checked_field("TestStudent1 Student")
  expect(page).to have_checked_field("TestStudent2 Student")
  expect(page).to have_checked_field("TestStudent3 Student")
end

When('I click Delete on a course and dismiss the popup') do
  delete_button = find(".td", text: "TestCourse1").find(:xpath, "..").find_button("Delete")
  dismiss_confirm do
    delete_button.click
  end
end

When('I click Delete on a course and accept the popup') do
  delete_button = find(".td", text: "TestCourse1").find(:xpath, "..").find_button("Delete")
  accept_confirm do
    delete_button.click
  end
end

When('I should see the course in the list') do
  expect(page).to have_text("TestCourse1")
end

When('I should not see the course in the list') do
  expect(page).to have_no_text("TestCourse1")
end