require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @auth = {
      'info' => {
        'name'     => "John Doe",
        'email'    => "email@example.com",
        'nickname' => "john",
        'image'    => "image"
      },
      'credentials' => {
        'token' => "a token",
        'secret' => "a secret"
      },
      'extra' => {
        'raw_info' => {
          'gravatar_id' => "gravatar",
          'avatar_url' => "avatar_url"
        }
      },
      'provider' => 'provider',
      'uid' => 'uid'
    }
    @user = User.create_with_omniauth!(@auth)
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
      :name  => "John Doe",
      :email => "email@example.com",
      :image => "image"
    }

    assert User.omniauth_attributes(@auth) == expected
  end

  test "omniauth_attributes should parse auth hash and return user attributes" do
    assert @user.omniauth_attributes(@auth) == {}
    
    @user.image = ''
    assert @user.omniauth_attributes(@auth) == { :image => "image" }
  end
end
