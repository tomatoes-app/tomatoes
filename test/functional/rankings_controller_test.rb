require 'test_helper'

class RankingsControllerTest < ActionController::TestCase
  test 'should get today' do
    get :index, time_period: 'today'
    assert_response :success
  end

  test 'should get this_week' do
    get :index, time_period: 'this_week'
    assert_response :success
  end

  test 'should get this_month' do
    get :index, time_period: 'this_month'
    assert_response :success
  end

  test 'should get all_time' do
    get :index, time_period: 'all_time'
    assert_response :success
  end
end
