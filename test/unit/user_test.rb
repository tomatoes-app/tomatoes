require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "User.find_by_omniauth" do
    pending
    
    assert true
  end
  
  test "User.create_with_omniauth!" do
    pending
    
    assert true
  end
  
  test "update_omniauth_attributes!" do
    pending
    
    assert true
  end
  
  test "User.omniauth_attributes should parse auth hash and return user attributes" do
    pending
    
    # attributes = {}
    
    # if auth['user_info']
    #   attributes.merge!({
    #     :name => auth['user_info']['name'], # Twitter, Google, Yahoo, GitHub
    #     :email => auth['user_info']['email'], # Google, Yahoo, GitHub
    #     :login => auth['user_info']['nickname'], # GitHub
    #     :token => auth['credentials']['token'] # GitHub
    #   })
    # end
    
    # if auth['extra']['user_hash']
    #   attributes.merge!({
    #     :name => auth['extra']['user_hash']['name'], # Facebook
    #     :email => auth['extra']['user_hash']['email'], # Facebook
    #     :gravatar_id => auth['extra']['user_hash']['gravatar_id'] # GitHub
    #   })
    # end
    
    # attributes

    auth = {
      'user_info' => {
        'name' => "John Doe",
        'email' => "email@example.com",
        'login' => "john"
      },
      'credentials' => {
        'token' => "a token"
      },
      'extra' => {
        'user_hash' => {
          # TODO!
        }
      }
    }

    expected = {

    }

    assert User.omniauth_attributes(auth) == expected
  end
end
