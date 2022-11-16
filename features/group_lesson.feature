Feature: Group Lesson

As a teacher
I should be able to teach a lesson to a group of students

Background:
  Given I am registered as a teacher
  And I am logged in
  And Testing schools exist

Scenario: See a link to page Start Group Lesson
  When I visit the homepage
  Then I see a link to the Start Group Lesson page

Scenario: Go to page Start Group Lesson
  When I visit the homepage
  When I click the link to the Start Group Lesson page
  Then I am at the Start Group Lesson page

Scenario: Prompt to confirm create first student on Group Lesson page
  Given I have not taught any lessons
  * I go to the Start Group Lesson page
  * The first student is not in the database
  When I enter the first student name
  * I select a school
  Then I click Add Student and I click No on the confirmation dialog

Scenario: Cancel create first student on Group Lesson page
  Given I have not taught any lessons
  * I go to the Start Group Lesson page
  * The first student is not in the database
  * I enter the first student name
  * I select a school
  When I click Add Student and I click No on the confirmation dialog
  Then I am at the Start Group Lesson page
  * The first student is not in the database

Scenario: Confirm create first student on Group Lesson page
  Given I have not taught any lessons
  * I go to the Start Group Lesson page
  * The first student is not in the database
  * I enter the first student name
  * I select a school
  When I click Add Student and I click Yes on the confirmation dialog
  Then I am at the Start Group Lesson page
  * The first student appears on the page

Scenario: Finish first lesson
  Given I have not taught any lessons
  * I go to the Start Group Lesson page
  * The first student is not in the database
  * The second student is not in the database
  * I enter the first student name
  * I select a school
  * I click Add Student and I click Yes on the confirmation dialog
  * I enter the second student name
  * I select a school
  * I click Add Student and I click Yes on the confirmation dialog
  * I click Start Lesson
  * I am at the Group Lesson Checkout page
  * I enter notes for each student
  * I enter notes for the group
  When I click Finish Lesson
  Then I am at the Start Group Lesson page
  * A group lesson with my first 2 students is in the database
  * The end time of the lesson is accurate
  * The lesson contains notes for each student
  * The lesson contains notes for the group

Scenario: Student list size 1
  Given I have taught 1 students
  When I go to the Start Group Lesson page
  Then I have the option to teach a group lesson to 1 students

Scenario: Student list size 2
  Given I have taught 2 students
  When I go to the Start Group Lesson page
  Then I have the option to teach a group lesson to 2 students

Scenario: Student list size 3
  Given I have taught 3 students
  When I go to the Start Group Lesson page
  Then I have the option to teach a group lesson to 3 students

Scenario: Students not taught are not listed
  When I go to the Start Group Lesson page
  Then No students are listed in group lesson

Scenario: Teach a group lesson to previous students
  Given I have taught 2 students
  * I go to the Start Group Lesson page
  * I select 2 students for the group lesson
  * I click Start Lesson
  * I am at the Group Lesson Checkout page
  When I click Finish Lesson
  Then I am at the Start Group Lesson page
  * A group lesson with my first 2 students is in the database
  * The end time of the lesson is accurate

Scenario: Teach a group lesson to existing students who are new to me
  Given Other students exist
  * I go to the Start Group Lesson page
  * I enter the other student name 1
  * I select school 1
  * I click Add Student
  * I enter the other student name 2
  * I select school 2
  * I click Add Student
  * I enter the other student name 3
  * I select school 3
  * I click Add Student
  * I click Start Lesson
  * I am at the Group Lesson Checkout page
  When I click Finish Lesson
  Then I am at the Start Group Lesson page
  * A group lesson with 3 students is in the database
  * The end time of the lesson is accurate

Scenario: Add new students to a lesson in progress
  Given Other students exist
  * I go to the Start Group Lesson page
  * I enter the other student name 1
  * I select school 1
  * I click Add Student
  * I enter the other student name 2
  * I select school 2
  * I click Add Student
  * I click Start Lesson
  * I am at the Group Lesson Checkout page
  When I enter the first student name
  * I select a school
  * I click Add Student and I click Yes on the confirmation dialog
  * I enter the second student name
  * I select a school
  * I click Add Student and I click Yes on the confirmation dialog
  Then The first student appears on the page
  * The second student appears on the page
  * I click Finish Lesson
  * I am at the Start Group Lesson page
  * A group lesson with 4 students is in the database
  * The end time of the lesson is accurate
