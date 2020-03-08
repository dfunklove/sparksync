require 'test_helper'

class GroupLessonsControllerTest < ActionDispatch::IntegrationTest
  def params_for_student(student, index, selected)
    retval = {}
    retval["group_lesson[lessons_attributes][#{index}][student_id]"] = student.id
    retval["group_lesson[lessons_attributes][#{index}][school_id]"] = student.school.id
    retval["group_lesson[lessons_attributes][#{index}][brought_instrument]"] = 1
    retval["group_lesson[lessons_attributes][#{index}][brought_books]"] = 1
    retval["group_lesson[lessons_attributes][#{index}][selected]"] = true if selected
    retval
  end

  def params_for_add_student(student, index)
    retval = {}
    retval["group_lesson[lessons_attributes][#{index}][student][first_name]"] = student.first_name
    retval["group_lesson[lessons_attributes][#{index}][student][last_name]"] = student.last_name
    retval["group_lesson[lessons_attributes][#{index}][student][school_id]"] = student.school.id
    retval["group_lesson[lessons_attributes][#{index}][brought_instrument]"] = 1
    retval["group_lesson[lessons_attributes][#{index}][brought_books]"] = 1
    retval
  end

  def setup
    login
  end

  def login
    post "/login", params: { "session[email]" => "charL@yahoo.edu", 
      "session[password]" => "testchar" }
    assert_nil flash[:danger]
    assert_redirected_to root_url, "Unable to login"
  end

  test "two listed students" do
    students = Student.limit(5)

    # Select students 1 and 3
    params = {}
    for i in 0..4 do
      params.merge! params_for_student(students[i], i, i.odd?)
    end

    count_before = GroupLesson.count
    post "/group_lessons", params: params, xhr: true
    assert_nil flash[:danger]
    assert_match "group_lessons/checkout", @response.body
    assert_match /action.*replace/, @response.body
    assert_not_nil session[:group_lesson_id]
    assert_equal count_before + 1, GroupLesson.count
  end

  test "add existing student" do
    params = params_for_add_student(Student.first, 0)
    params["add_student"] = true
    post "/group_lessons", params: params, xhr: true
    assert_template :create
  end

  test "add new student without confirmation" do
    s = Student.new
    s.first_name = "Test"
    s.last_name = "1"
    s.school = School.first
    params = params_for_add_student(s, 0)
    params["add_student"] = true
    post "/group_lessons", params: params, xhr: true
    assert_template :confirm_add_student
  end

  test "add new student with confirmation" do
    count_before = Student.count
    s = Student.new
    s.first_name = "Test"
    s.last_name = "1"
    s.school = School.first
    params = params_for_add_student(s, 0)
    params["add_student"] = true
    params["new_student"] = true
    post "/group_lessons", params: params, xhr: true
    assert_template :create
    assert_equal count_before + 1, Student.count
  end

  test "add new student without confirmation" do
    s = Student.new
    s.first_name = "Test"
    s.last_name = "1"
    s.school = School.first
    params = params_for_add_student(s, 0)
    params["add_student"] = true
    post "/group_lessons", params: params, xhr: true
    assert_template :confirm_add_student
  end
end
