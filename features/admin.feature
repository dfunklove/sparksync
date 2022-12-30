Feature: Admin

As an Admin
I should be able to create and/or modify admins

Background:
Given Testing admins exist
Given I am registered as an admin
Given I am logged in
Given I go to Admins

Scenario: Reset admin password
When I click Reset on an admin
Then I should be informed that a password reset email was sent to the admin

Scenario: Change view from Active to All to Inactive
When I click the Active button
Then I should see the All button
When I click the All button
Then I should see the Inactive button
When I click the Inactive button
Then I should see the Active button

Scenario: Create admin
When I click Send
Then I should be asked to enter a first name, last name, and email
When I enter a first name, last name, and invalid email for a new admin
When I click Send
Then I should be asked to enter a valid email
When I enter a first name, last name, and valid email for a new admin
When I click Send
Then I should be informed that a welcome email was sent to the new admin
Then I should see the new admin

Scenario: Update admin
When I enter a new first name, last name, and email for the admin
When I click Modify on the admin
Then I should be informed that the admin was modified
Then I should see the updated admin

Scenario: Activate and Deactivate admin
When I click Deactivate on the admin
Then I should be informed that the admin was deactivated
Then I should not see the admin
When I click the Active button
Then I should see the All button
Then I should see an Activate button for the admin
When I click Activate on admin
Then I should be informed that the admin was activated
Then I should see a Deactivate button for the admin
When I click the All button
Then I should see the Inactive button
Then I should not see the admin

Scenario: Delete admin
When I click the Active button
Then I should see the All button
When I click Deactivate on the admin
Then I should be informed that the admin was deactivated
When I click Delete on admin and dismiss the popup
Then I should see a Delete button for the admin
When I click Delete on admin and confirm the popup
Then I should be informed that the admin was deleted
Then I should not see the admin
