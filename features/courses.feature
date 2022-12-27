Feature: Courses

As a teacher
I should be able to teach a course which has been assigned to me

Background:
  Given Testing schools exist
  Given Other students exist
  Given I am registered as a teacher
  And I am logged in

Scenario: Message when no courses
Given I go to the courses page
When I have no courses
Then I see the message for no courses

Scenario: Teach a course
Given Testing courses exist
* I go to the courses page
* I have a course
* I click Teach this session
* I am at the Attendance page
* I click Start Lesson
* I am at the Group Lesson Checkout page
* I click Finish Lesson
* I go to My Records
* The test course is in the list

Scenario: Mark student as not present
Given Testing courses exist
Given I go to the courses page
* I have a course
* I click Teach this session
* I am at the Attendance page
* There are 3 students in the list
* I mark 1 students as not present
* I click Start Lesson
* There are 2 students in the list
* I click Finish Lesson
* I go to My Records
* I expand the group lesson record
* There are 2 students in the group lesson record