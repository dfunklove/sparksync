require 'test_helper'

class LessonsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get lessons_new_url
    assert_response :success
  end

end
