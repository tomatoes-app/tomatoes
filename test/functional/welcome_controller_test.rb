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
    # It includes the public header
    assert(
      response.body.include?(
        'Tomatoes is a Pomodoro Technique<sup>®</sup> driven time tracker'
      )
    )
    # It doesn't include the current user's list of tomatoes
    assert_not response.body.include? 'Today&#39;s tomatoes'
  end

  test 'current user should get index' do
    session[:user_id] = @user.id

    get :index
    assert_response :success
    # It doesn't include the public header
    assert_not(
      response.body.include?(
        'Tomatoes is a Pomodoro Technique<sup>®</sup> driven time tracker'
      )
    )
    # It includes the current user's list of tomatoes
    assert response.body.include? 'Today&#39;s tomatoes'
  end
end
