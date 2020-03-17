require 'test_helper'

class LessonsControllerTest < ActionDispatch::IntegrationTest

  def params_for_student student
    retval = {}
    retval["lesson[student_id]"] = student.id
    retval["lesson[school_id]"] = student.school.id
    retval["lesson[student][school_id]"] = student.school.id
    retval["lesson[brought_instrument]"] = 1
    retval["lesson[brought_books]"] = 1
    retval
  end

  def params_for_new_student student
    retval = {}
    retval["lesson[student][first_name]"] = student.first_name
    retval["lesson[student][last_name]"] = student.last_name
    retval["lesson[student][school_id]"] = student.school.id
    retval["lesson[brought_instrument]"] = 1
    retval["lesson[brought_books]"] = 1
    retval
  end

  def setup
    teacher_login
  end

  test "create lesson with existing student" do
    count_before = Lesson.count
    params = params_for_student Student.first

    post "/lessons", params: params, xhr: true

    assert_match "lessons/checkout", @response.body
    assert_match /action.*replace/, @response.body
    assert_not_nil session[:lesson_id]
    assert_equal count_before + 1, Lesson.count
  end

  test "create lesson with new student without confirmation" do
    lesson_count_before = Lesson.count
    student_count_before = Student.count
    s = Student.new
    s.first_name = "Test"
    s.last_name = "1"
    s.school = School.first
    params = params_for_new_student s

    post "/lessons", params: params, xhr: true

    assert_template :confirm_add_student
    assert_equal lesson_count_before, Lesson.count
    assert_equal student_count_before, Student.count
  end

  test "create lesson with new student with confirmation" do
    lesson_count_before = Lesson.count
    student_count_before = Student.count
    s = Student.new
    s.first_name = "Test"
    s.last_name = "1"
    s.school = School.first
    params = params_for_new_student s
    params["add_student_confirmed"] = true

    post "/lessons", params: params, xhr: true

    assert_match "lessons/checkout", @response.body
    assert_match /action.*replace/, @response.body
    assert_not_nil session[:lesson_id]
    assert_equal lesson_count_before + 1, Lesson.count
    assert_equal student_count_before + 1, Student.count
  end
end
