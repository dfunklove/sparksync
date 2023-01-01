admin_email = "test_admin1@example.com"
admin_first_name = "Test1"
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
  expect(page).to have_no_text("#{record_id}")
end

Then('I should be informed that a welcome email was sent to the new admin') do
  expect(page).to have_text("A welcome email was sent to #{new_admin_email}")
end

Then('I should be informed that a password reset email was sent to the admin') do
  expect(page).to have_text("A password reset email was sent to #{admin_email}")
end

Then('I should be informed that the admin was modified') do
  expect(page).to have_text("#{admin_first_name} #{admin_last_name} was modified")
end

Then('I should be informed that the record was activated') do
  expect(page).to have_text("was activated")
end

Then('I should be informed that the record was deactivated') do
  expect(page).to have_text("was deactivated")
end

Then('I should be informed that the record was deleted') do
  expect(page).to have_text("was deleted")
end

