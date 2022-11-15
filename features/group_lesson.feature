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
  * I click Add Student
  Then I am prompted to confirm creation of the student

Scenario: Cancel create first student on Group Lesson page
  Given I have not taught any lessons
  * I go to the Start Group Lesson page
  * The first student is not in the database
  * I enter the first student name
  * I select a school
  * I click Add Student
  When I click No on the create student confirmation dialog
  Then I am at the Start Group Lesson page
  * The first student is not in the database

Scenario: Confirm create first student on Group Lesson page
  Given I have not taught any lessons
  * I go to the Start Group Lesson page
  * The first student is not in the database
  * I enter the first student name
  * I select a school
  * I click Add Student
  When I click Yes on the create student confirmation dialog
  Then I am at the Start Group Lesson page
  * The first student appears on the page

Scenario: Finish first lesson
  Given I have not taught any lessons
  * I go to the Start Group Lesson page
  * The first student is not in the database
  * The second student is not in the database
  * I enter the first student name
  * I select a school
  * I click Add Student
  * I click Yes on the create student confirmation dialog
  * I enter the second student name
  * I select a school
  * I click Add Student
  * I click Yes on the create student confirmation dialog
  * I click Start Lesson
  * I am at the Group Lesson Checkout page
  When I click Finish Lesson
  Then I am at the Start Group Lesson page
  * A group lesson with 2 students is in the database
  * The end time of the lesson is accurate

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