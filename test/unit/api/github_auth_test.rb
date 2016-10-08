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
      @github_client.expects(:user).returns('id' => 'github_user_id')

      auth = GithubAuth.new('github_access_token')
      assert_equal @github_user, auth.find_user
    end

    test 'find_user does not return any user if not present' do
      Octokit::Client.stubs(:new).with(access_token: 'github_access_token').returns(@github_client)
      @github_client.expects(:user).returns('id' => 'missing_user')

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
  end
end
