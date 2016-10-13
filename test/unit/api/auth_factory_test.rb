require 'test_helper'

module Api
  class AuthFactoryTest < ActiveSupport::TestCase
    test 'self.build github provider' do
      auth = AuthFactory.build(provider: 'github')
      assert_kind_of GithubAuth, auth
    end

    test 'self.build twitter provider' do
      auth = AuthFactory.build(provider: 'twitter')
      assert_kind_of TwitterAuth, auth
    end

    test 'self.build invalid provider' do
      assert_raises(Error::ProviderNotSupported) do
        AuthFactory.build(provider: 'invalid provider')
      end
    end
  end
end
