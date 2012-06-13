require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.create(
      :provider => "provider",
      :uid => "uid",
      :name => "name",
      :email => "email",
      :login => "login"
    )
    @auth = {
      'info' => {
        'name'     => "John Doe",
        'email'    => "email@example.com",
        'nickname' => "john"
      },
      'credentials' => {
        'token' => "a token",
        'secret' => "a secret"
      },
      'extra' => {
        'raw_info' => {
          'gravatar_id' => "gravatar"
        }
      },
      'provider' => 'provider',
      'uid' => 'uid'
    }
  end
  
  teardown do
    @user.destroy
  end

  test "self.find_by_omniauth" do
    assert User.find_by_omniauth(@auth) == @user
  end
  
  test "self.create_with_omniauth!" do
    pending
    
    assert true
  end
  
  test "update_omniauth_attributes!" do
    pending
    
    assert true
  end
  
  test "self.omniauth_attributes should parse auth hash and return user attributes" do
    expected = {
      :name        => "John Doe",
      :email       => "email@example.com",
      :login       => "john",
      :gravatar_id => "gravatar"
    }

    assert User.omniauth_attributes(@auth) == expected
  end
end
