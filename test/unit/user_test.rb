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
  end
  
  teardown do
    User.destroy_all
  end

  test "self.find_by_omniauth" do
    user = User.create_with_omniauth!(@auth)

    assert_equal User.find_by_omniauth(@auth), user
  end
  
  test "self.create_with_omniauth!" do
    user = User.create_with_omniauth!(@auth)
    
    assert_equal user.name, 'John Doe'
    assert_equal user.email, 'email@example.com'
  end

  test "self.create_with_omniauth! with invalid email" do
    @auth['info']['email'] = 'invalid email'

    assert_nothing_raised { User.create_with_omniauth!(@auth) }
  end
  
  test "update_omniauth_attributes! doesn't update existing user data" do
    user = User.create_with_omniauth!(@auth)
    user.update_omniauth_attributes!(@auth.merge('info' => { 'name' => 'Johnny Doe' }))
    
    assert_equal user.name, 'John Doe'
  end

  test "update_omniauth_attributes! updates missing user data" do
    user = User.create_with_omniauth!(@auth)
    user.name = ''
    user.update_omniauth_attributes!(@auth.merge('info' => { 'name' => 'Johnny Doe' }))
    
    assert_equal user.name, 'Johnny Doe'
  end
  
  test "self.omniauth_attributes should parse auth hash and return user attributes" do
    expected = {
      name:  "John Doe",
      email: "email@example.com",
      image: "image"
    }

    assert_equal User.omniauth_attributes(@auth), expected
  end

  test "omniauth_attributes shouldn't return auth data for existing attributes" do
    user = User.create_with_omniauth!(@auth)

    assert_equal user.omniauth_attributes(@auth), { :image => "image" }
  end

  test "omniauth_attributes should return auth data for empty user attributes" do
    user = User.create_with_omniauth!(@auth)
    user.email = ''

    assert_equal user.omniauth_attributes(@auth), { :email => "email@example.com", :image => "image" }
  end

  test "nickname should return first authorization's nickname" do
    user = User.create_with_omniauth!(@auth)

    assert_equal user.nickname, "john"
  end

  test "image_file should return user image" do
    user = User.create_with_omniauth!(@auth)

    assert_equal "image", user.image_file
  end

  test "image_file should return default image if image attribute is empty" do
    user = User.create_with_omniauth!(@auth.merge('info' => { 'image' => '' }))

    assert_equal User::DEFAULT_IMAGE_FILE, user.image_file
  end
end
