Feature: Single Lesson

As a teacher
I should be able to teach a lesson to one student

Background:
  Given Testing schools exist
  And Testing students exist
  And Testing teachers exist
  And I am logged in as a teacher

Scenario: See a link to page Start Single Lesson
  When I visit the homepage
  Then I see a link to the Start Single Lesson page

Scenario: Go to page Start Single Lesson
  When I visit the homepage
  When I click the link to the Start Single Lesson page
  Then I am at the Start Single Lesson page

Scenario: Finish first lesson
  Given I go to the Start Single Lesson page
  * I enter a student name
  * I select a school from the add student form
  * I click Start Lesson on the add student form
  * I am at the Single Lesson Checkout page
  * I enter a note
  When I click Finish Lesson
  Then I am at the Start Single Lesson page
  * I go to My Records
  * I see the lesson I created

Scenario: Student list size 1
  Given I have taught 1 students
  When I go to the Start Single Lesson page
  Then I have the option to teach a single lesson to 1 students

Scenario: Student list size 2
  Given I have taught 2 students
  When I go to the Start Single Lesson page
  Then I have the option to teach a single lesson to 2 students

Scenario: Student list size 3
  Given I have taught 3 students
  When I go to the Start Single Lesson page
  Then I have the option to teach a single lesson to 3 students

Scenario: Students not taught are not listed
  When I go to the Start Single Lesson page
  Then No students are listed on the Start Single Lesson page