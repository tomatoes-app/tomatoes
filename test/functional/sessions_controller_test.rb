require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  setup do
    # @user = users(:one)
    @user = User.create(
      :provider => "provider",
      :uid => "uid",
      :name => "name",
      :email => "email",
      :login => "login"
    )
  end
  
  teardown do
    @user.destroy
  end
  
  test "should get new" do
    get :new, :provider => 'github'
    assert_redirected_to '/auth/github'
  end

  test "should get create" do
    User.expects(:find_by_omniauth).returns(@user)
    @user.expects(:update_omniauth_attributes!)
    
    get :create, :provider => 'github'
    assert_equal @user.id, session[:user_id]
    assert_redirected_to root_url
    assert_equal 'Signed in!', flash[:notice]
  end
  
  test "should get destroy" do
    get :destroy
    assert_equal nil, session[:user_id]
    assert_redirected_to root_url
    assert_equal 'Signed out!', flash[:notice]
  end
  
  test "should get failure" do
    get :failure, :message => 'failure message'
    assert_equal nil, session[:user_id]
    assert_redirected_to root_url
    assert_equal "Authentication error: #{'failure message'.humanize}", flash[:alert]
  end
end
