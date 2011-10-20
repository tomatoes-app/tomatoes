require 'test_helper'

class RankingControllerTest < ActionController::TestCase
  test "should get today" do
    get :today
    assert_response :success
  end

  test "should get this_week" do
    get :this_week
    assert_response :success
  end

  test "should get this_month" do
    get :this_month
    assert_response :success
  end

  test "should get all_time" do
    get :all_time
    assert_response :success
  end

end
