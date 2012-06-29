require 'test_helper'

class StatisticsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get users_by_tomatoes" do
    get :users_by_tomatoes, :format => :json
    assert_response :success
  end

  test "should get users_by_day" do
    get :users_by_day, :format => :json
    assert_response :success
  end

  test "should get tomatoes_by_day" do
    get :tomatoes_by_day, :format => :json
    assert_response :success
  end
end
