Feature: Admin

As an Admin
I should be able to create and/or modify admins, partners, teachers, schools, and students

Background:
Given Testing admins exist
Given Testing partners exist
Given Testing teachers exist
Given Testing schools exist
Given Testing students exist
Given I am registered as an admin
Given I am logged in
Given I go to Admins

Scenario: Reset admin password
When I click Reset on the admin
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

Scenario Outline: Activate, Deactivate and Delete
When I go to the page for model <model_name>
When I click Deactivate on record <record_id>
Then I should be informed that the record was deactivated
Then I should not see record <record_id>
When I click the Active button
Then I should see the All button
Then I should see an Activate button for record <record_id>
When I click Activate on record <record_id>
Then I should be informed that the record was activated
Then I should see a Deactivate button for record <record_id>
When I click the All button
Then I should see the Inactive button
Then I should not see record <record_id>
When I click the Inactive button
When I click the Active button
When I click Deactivate on record <record_id>
Then I should be informed that the record was deactivated
When I click Delete on record <record_id> and dismiss the popup
Then I should see a Delete button for record <record_id>
When I click Delete on record <record_id> and confirm the popup
Then I should be informed that the record was deleted
Then I should not see record <record_id>

Examples:
|model_name | record_id                 |
|admin      | test_admin1@example.com   |
|partner    | test_partner1@example.com |
|school     | Test1                     |
|student    | Test1                     |
|teacher    | test_teacher1@example.com |