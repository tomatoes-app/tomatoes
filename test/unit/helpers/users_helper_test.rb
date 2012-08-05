require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test "profile_image" do
    pending
  end

  test "user_name should return the user name link" do
    stubs(:users_path)
    @name = "John"
    @user = User.new(:name => @name)
    
    assert user_name(@user).match(Regexp.escape(@name))
  end
end
