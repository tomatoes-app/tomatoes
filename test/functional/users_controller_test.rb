require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    # @user = users(:one)
    @user = User.create(
      :provider => "provider",
      :uid => "uid",
      :name => "name",
      :email => "email",
      :login => "login"
    )
    @controller.stubs(:current_user).returns(@user)
  end
  
  teardown do
    @user.destroy
  end

  test "should show user" do
    get :show, :id => @user.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user.to_param
    assert_response :success
  end

  test "should update user" do
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user.to_param
    end

    assert_redirected_to root_path
  end
end
