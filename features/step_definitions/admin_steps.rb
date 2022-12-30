admin_email = "test1@example.com"
admin_first_name = "Test1"
admin_last_name = "Admin"
new_admin_email = "imadethis@example.com"

def find_row_with_email(admin_email)
  tr = page.find(:xpath, ".//tr[.//input[@id='admin_email'][@value='#{admin_email}']]")
end

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
  tr = find_row_with_email(admin_email)
  tr.fill_in("admin_first_name", with: "UpdatedFirst")
  tr.fill_in("admin_last_name", with: "UpdatedLast")
  tr.fill_in("admin_email", with: "updated@example.com")  
end

Then('I should see the new admin') do
  tr = find_row_with_email(admin_email)
  expect(tr).to have_button("Reset")
end

Then('I should see the updated admin') do
  tr = find_row_with_email("updated@example.com")
  expect(tr.find('#admin_first_name')).to have_attributes(value: "UpdatedFirst")
  #expect(tr.find('#admin_last_name')).to have_value("UpdatedLast")
end

When('I click Reset on an admin') do
  tr = find_row_with_email(admin_email)
  tr.find_button('Reset').click
end

When('I click modify on the admin') do
  tr = find_row_with_email(admin_email)
  tr.find_button('Modify').click
end

When('I click Activate on admin') do
  tr = find_row_with_email(admin_email)
  tr.find_button('Activate').click
end

When('I click Deactivate on the admin') do
  tr = find_row_with_email(admin_email)
  tr.find_button('Deactivate').click
end

When('I click Delete on admin and dismiss the popup') do
  tr = find_row_with_email(admin_email)
  dismiss_confirm do
    tr.find_button('Delete').click
  end
end

When('I click Delete on admin and confirm the popup') do
  tr = find_row_with_email(admin_email)
  accept_confirm do
    tr.find_button('Delete').click
  end
end

Then('I should see an Activate button for the admin') do
  tr = find_row_with_email(admin_email)
  expect(tr).to have_button("Activate")
end

Then('I should see a Deactivate button for the admin') do
  tr = find_row_with_email(admin_email)
  expect(tr).to have_button("Deactivate")
end

Then('I should see a Delete button for the admin') do
  tr = find_row_with_email(admin_email)
  expect(tr).to have_button("Delete")
end

Then('I should not see the admin') do
  expect(page).to have_no_text("#{admin_email}")
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

Then('I should be informed that the admin was activated') do
  expect(page).to have_text("#{admin_first_name} #{admin_last_name} was activated")
end

Then('I should be informed that the admin was deactivated') do
  expect(page).to have_text("#{admin_first_name} #{admin_last_name} was deactivated")
end

Then('I should be informed that the admin was deleted') do
  expect(page).to have_text("#{admin_first_name} #{admin_last_name} was deleted")
end

