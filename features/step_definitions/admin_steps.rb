Given('I go to Admins') do
  visit '/admins'
end

When('I click Reset on an admin with email {word}') do |email|
  tr = page.find(:xpath, ".//tr[.//input[@id='admin_email'][@value='#{email}']]")
  tr.find_button('Reset').click
end

Then('I should be informed that a password reset email was sent to the admin with email {word}') do |email|
  expect(page).to have_text("A password reset email was sent to #{email}")
end

When('I click Send') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should be asked to enter a first name, last name, and email') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I enter a first name, last name, and invalid email for a new admin') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should be asked to enter a valid email') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I enter a first name, last name, and valid email for a new admin') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should be informed that a welcome email was sent to the admin with email X') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see an admin with first name X, last name Y, and email Z') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I enter a new first name, last name, and email for admin with email X') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I click modify on admin with email X') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should be informed that the admin with email X was modified') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I click Deactivate on admin with email X') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should be informed that the admin with email X was deactivated') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should not see the admin with email X') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see an Activate button for the admin with email X') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I click Activate on admin with email X') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should be informed that the admin with email X was activated') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see a Deactivate button for the admin with email X') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I click Delete on admin with email X and dismiss the popup') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see a Delete button for the admin with email X') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I click Delete on admin with email X and confirm the popup') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should be informed that the admin with email X was deleted') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I click the Active button') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see the All button') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I click the All button') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see the Inactive button') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I click the Inactive button') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see the Active button') do
  pending # Write code here that turns the phrase above into concrete actions
end

