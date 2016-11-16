require 'test_helper'

module Api
  class GithubAuthTest < ActiveSupport::TestCase
    setup do
      @github_user = User.create!(
        name: 'name',
        email: 'email@example.com'
      )
      @github_user.authorizations.create!(
        provider: 'github',
        uid: 'github_user_id'
      )

      @github_client = Octokit::Client.new
    end

    teardown do
      @github_user.destroy
    end

    test 'find_user returns the right github user if present' do
      Octokit::Client.stubs(:new).with(access_token: 'github_access_token').returns(@github_client)
      @github_client.expects(:user).returns(id: 'github_user_id')

      auth = GithubAuth.new('github_access_token')
      assert_equal @github_user, auth.find_user
    end

    test 'find_user returns the right github user if present with numeric ID' do
      @github_user.authorizations.create!(
        provider: 'github',
        uid: '1'
      )
      Octokit::Client.stubs(:new).with(access_token: 'github_access_token').returns(@github_client)
      @github_client.expects(:user).returns(id: 1)

      auth = GithubAuth.new('github_access_token')
      assert_equal @github_user, auth.find_user
    end

    test 'find_user does not return any user if not present' do
      Octokit::Client.stubs(:new).with(access_token: 'github_access_token').returns(@github_client)
      @github_client.expects(:user).returns(id: 'missing_user')

      auth = GithubAuth.new('github_access_token')
      assert_nil auth.find_user
    end

    test 'find_user raises an exception if unauthorized' do
      Octokit::Client.stubs(:new).with(access_token: 'invalid_token').returns(@github_client)
      @github_client.expects(:user).raises(Octokit::Unauthorized)

      auth = GithubAuth.new('invalid_token')
      assert_raises(Error::Unauthorized) do
        auth.find_user
      end
    end

    test 'create_user! creates a new user from github data' do
      Octokit::Client.stubs(:new).with(access_token: 'github_access_token').returns(@github_client)
      @github_client.expects(:user).returns(
        id: '123',
        name: 'Giovanni',
        email: 'giovanni@tomato.es',
        avatar_url: 'giovanni.png',
        login: 'potomak'
      )

      auth = GithubAuth.new('github_access_token')
      user = nil
      assert_difference('User.count') do
        user = auth.create_user!
      end
      assert_kind_of User, user
      assert_equal 'Giovanni', user.name
      assert_equal 'giovanni@tomato.es', user.email
      assert_equal 'giovanni.png', user.image
      assert_equal '123', user.authorizations.first.uid
      assert_equal 'github', user.authorizations.first.provider
      assert_equal 'github_access_token', user.authorizations.first.token
      assert_equal 'potomak', user.authorizations.first.nickname
      assert_equal 'giovanni.png', user.authorizations.first.image
    end

    test 'create_user! raises an exception if unauthorized' do
      Octokit::Client.stubs(:new).with(access_token: 'invalid_token').returns(@github_client)
      @github_client.expects(:user).raises(Octokit::Unauthorized)

      auth = GithubAuth.new('invalid_token')
      assert_raises(Error::Unauthorized) do
        auth.create_user!
      end
    end
  end
end
