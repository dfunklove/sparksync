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

  @@once = false

  def setup
    if !@@once
      @@once = true
      login
   end
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
    post "/group_lessons", params: params
    assert_nil flash[:danger]
    assert_redirected_to controller: :group_lessons, action: :checkout
    assert_not_nil session[:group_lesson_id]
    assert_equal count_before + 1, GroupLesson.count
  end
end
