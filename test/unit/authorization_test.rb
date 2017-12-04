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

  teardown do
    User.destroy_all
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

  test 'self.external_providers should not include internal API authorizations' do
    user = User.create!
    github_auth = user.authorizations.create!(token: '123', provider: Authorization::PROVIDER_GITHUB)
    twitter_auth = user.authorizations.create!(token: '456', provider: Authorization::PROVIDER_TWITTER)
    api_auth = user.authorizations.create!(token: '456', provider: Authorization::PROVIDER_API)

    assert user.authorizations.count == 3
    assert user.authorizations.external_providers.include?(github_auth)
    assert user.authorizations.external_providers.include?(twitter_auth)
    assert !user.authorizations.external_providers.include?(api_auth)
  end
end
