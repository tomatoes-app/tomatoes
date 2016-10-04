require 'test_helper'

class AuthorizationTest < ActiveSupport::TestCase
  setup do
    @auth = {
      'credentials' => {
        'token' => 'a token',
        'secret' => 'a secret'
      },
      'provider' => 'provider',
      'uid' => 'uid'
    }
  end

  test 'self.omniauth_attributes should parse auth hash and return authorization attributes' do
    expected = {
      provider: 'provider',
      uid: 'uid',
      token: 'a token',
      secret: 'a secret'
    }

    assert Authorization.omniauth_attributes(@auth) == expected
  end
end
