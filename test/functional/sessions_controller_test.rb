require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_redirected_to '/auth/github'
  end

  test "should get create" do
    pending
  end
  
  test "should get destroy" do
    pending
  end
  
  test "should get failure" do
    pending
  end
end
