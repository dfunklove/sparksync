Feature: Admin

As an Admin
I should be able to create and/or modify admins, courses, partners, schools, students, and teachers

Background:
Given Testing admins exist
Given Testing partners exist
Given Testing teachers exist
Given Testing schools exist
Given Testing students exist
Given I am registered as an admin
Given I am logged in
Given I go to Admins

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
Then I should be informed that a welcome email was sent
Then I should see the new admin

Scenario: Update admin
When I enter a new first name, last name, and email for the admin
When I click Modify on the admin
Then I should be informed that the admin was modified
Then I should see the updated admin

Scenario: Reset admin password
When I click Reset on the admin
Then I should be informed that a password reset email was sent to the admin

Scenario: Create course
When I go to the courses page
* I click New Session
* I click Create Session
* I should be asked to enter a name, teacher, school, and students
* I fill in the info for the course
* I click Create Session
* I should see the new course in the list
* I click Edit on the new course
* I should see the course info I entered

Scenario: Create partner
When I go to the partners page
* I click Send
* I should be asked to enter a school, first name, last name, and email
* I enter a school, first name, last name, and invalid email for a new partner
* I click Send
* I should be asked to enter a valid email
* I enter a school, first name, last name, and valid email for a new partner
* I click Send
* I should be informed that a welcome email was sent
* I should see the new partner

Scenario: Create school
When I go to the schools page
* I click Create
* I should be asked to enter a name
* I enter a name for a new school
* I click Create
* I should be informed that a new school was created
* I should see the new school

Scenario: Create student
When I go to the students page
* I click Create
* I should be asked to enter a first name, last name, and school
* I enter a first name, last name, and school for a new student
* I click Create
* I should be informed that a new student was created
* I should see the new student

Scenario: Create teacher
When I go to the teachers page
* I click Send
* I should be asked to enter a irst name, last name, and email
* I enter a first name, last name, and invalid email for a new teacher
* I click Send
* I should be asked to enter a valid email
* I enter a first name, last name, and valid email for a new teacher
* I click Send
* I should be informed that a welcome email was sent
* I should see the new teacher

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
|school     | Test_NoStudents           |
|student    | TestStudent1              |
|teacher    | test_teacher1@example.com |