require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test "user_avatar should return the user avatar <img> element" do
    @gravatar_id = "gravatar_id"
    @user = User.new(:gravatar_id => @gravatar_id)
    
    assert user_avatar(@user).match(Regexp.escape("http://gravatar.com/avatar/#{@gravatar_id}?s=24"))
  end
end
