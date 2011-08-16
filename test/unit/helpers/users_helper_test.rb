require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test "avatar should return the user avatar <img> element" do
    @gravatar_id = "gravatar_id"
    @user = User.new(:gravatar_id => @gravatar_id)
    
    assert avatar(@user).match(Regexp.escape("http://gravatar.com/avatar/#{@gravatar_id}?s=24"))
  end
  
  test "avatar should return the user avatar <img> element of the given size" do
    @gravatar_id = "gravatar_id"
    @user = User.new(:gravatar_id => @gravatar_id)
    @size = 48
    
    assert avatar(@user, @size).match(Regexp.escape("http://gravatar.com/avatar/#{@gravatar_id}?s=#{@size}"))
  end
  
  test "user_name should return the user name link" do
    stubs(:users_path)
    @name = "John"
    @user = User.new(:name => @name)
    
    assert user_name(@user).match(Regexp.escape(@name))
  end
  
  test "user_name should return the user login if name is empty" do
    stubs(:users_path)
    @login = "john"
    @user = User.new(:name => nil, :login => @login)
    
    assert user_name(@user).match(Regexp.escape(@login))
  end
end
