require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test "profile_image should return user profile image" do
    @image = "profile_image.png"
    @user = User.new(:image => @image)

    assert profile_image(@user).match(Regexp.escape(@image))
  end

  test "user_name should return the user name link" do
    stubs(:users_path)
    @name = "John"
    @user = User.new(:name => @name)
    
    assert user_name(@user).match(Regexp.escape(@name))
  end
end
