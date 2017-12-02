require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    # @user = users(:one)
    @user = User.create(
      provider: 'provider',
      uid: 'uid',
      name: 'name',
      email: 'email@example.com'
    )
    @controller.stubs(:current_user).returns(@user)
  end

  teardown do
    @user.destroy
  end

  test 'should show user' do
    get :show, params: { id: @user.to_param }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @user.to_param }
    assert_response :success
  end

  test 'should update user' do
    put :update, params: { id: @user.to_param, user: @user.attributes }
    assert_redirected_to user_path(@user)
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete :destroy, params: { id: @user.to_param }
    end

    assert_redirected_to root_path
  end

  test 'GET /show, '\
      'user time zone is invalid, '\
      'it uses the default time zone' do
    @user.update_attributes(time_zone: 'invalid')
    get :show, params: { id: @user.to_param }
    assert_response :success
  end
end
