require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  setup do
    @user = User.create!
  end

  teardown do
    User.destroy_all
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_template layout: 'welcome'
  end

  test 'current user should get index' do
    session[:user_id] = @user.id

    get :index
    assert_response :success
    assert_template layout: 'welcome'
  end
end
