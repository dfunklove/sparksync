Feature: Admin

As an Admin
I should be able to create and/or modify admins, lessons, partners, schools, sessions, students, teachers.

Background:
Given Testing admins exist
Given I am registered as an admin
Given I am logged in
Given I go to Admins

Scenario: Reset admin password
When I click Reset on an admin with email test1@example.com
Then I should be informed that a password reset email was sent to the admin with email test1@example.com

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
Then I should be informed that a welcome email was sent to the admin with email test1@example.com
Then I should see an admin with first name Test1, last name Admin, and email test1@example.com

Scenario: Update admin
When I enter a new first name, last name, and email for admin with email test1@example.com
When I click modify on admin with email test1@example.com
Then I should be informed that the admin with email test1@example.com was modified
Then I should see an admin with first name Test1, last name Admin, and email test1@example.com

Scenario: Activate and Deactivate admin
When I click Deactivate on admin with email test1@example.com
Then I should be informed that the admin with email test1@example.com was deactivated
Then I should not see the admin with email test1@example.com
When I click the Active button
Then I should see the All button
Then I should see an Activate button for the admin with email test1@example.com
When I click Activate on admin with email test1@example.com
Then I should be informed that the admin with email test1@example.com was activated
Then I should see a Deactivate button for the admin with email test1@example.com
When I click the All button
Then I should see the Inactive button
Then I should not see the admin with email test1@example.com

Scenario: Delete admin
When I click the Active button
Then I should see the All button
When I click Deactivate on admin with email test1@example.com
Then I should be informed that the admin with email test1@example.com was deactivated
When I click Delete on admin with email test1@example.com and dismiss the popup
Then I should see a Delete button for the admin with email test1@example.com
When I click Delete on admin with email test1@example.com and confirm the popup
Then I should be informed that the admin with email test1@example.com was deleted
Then I should not see the admin with email test1@example.com
