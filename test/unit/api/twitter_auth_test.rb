require 'test_helper'

module Api
  class TwitterAuthTest < ActiveSupport::TestCase
    setup do
      @twitter_user = User.create!(
        uid: '123',
        provider: 'twitter',
        name: 'Giovanni',
        image: ''
      )
      @twitter_api_user = Twitter::User.new(
        id: '123',
        name: 'Giovanni',
        screen_name: 'potomak'
      )
      @twitter_user.authorizations.create!(
        provider: 'twitter',
        uid: '123'
      )

      @twitter_client = Twitter::REST::Client
    end

    teardown do
      @twitter_user.destroy
    end

    test 'find_user returns the right twitter user if present' do
      Twitter::REST::Client.stubs(:new).returns(@twitter_client)
      @twitter_client.expects(:user).returns(@twitter_api_user)

      auth = TwitterAuth.new('twitter_access_token', 'twitter_secret')
      assert_equal @twitter_user, auth.find_user
    end

    test 'find_user raises an exception if unauthorized' do
      Twitter::REST::Client.stubs(:new).returns(@twitter_client)
      @twitter_client.expects(:user).raises(Twitter::Error::Unauthorized)

      auth = TwitterAuth.new('twitter_access_token', 'twitter_secret')
      assert_raises(Error::Unauthorized) do
        auth.find_user
      end
    end

    test 'create_user! creates a new user from twitter data' do
      Twitter::REST::Client.stubs(:new).returns(@twitter_client)
      @twitter_client.expects(:user).returns(@twitter_api_user)

      auth = TwitterAuth.new('twitter_access_token', 'twitter_secret')
      user = nil
      assert_difference('User.count') do
        user = auth.create_user!
      end
      assert_kind_of User, user
      assert_equal 'Giovanni', user.name
      assert_equal '123', user.authorizations.first.uid
      assert_equal 'twitter', user.authorizations.first.provider
      assert_equal 'twitter_access_token', user.authorizations.first.token
      assert_equal 'twitter_secret', user.authorizations.first.secret
      assert_equal 'potomak', user.authorizations.first.nickname
    end

    test 'create_user! raises an exception if unauthorized' do
      Twitter::REST::Client.stubs(:new).returns(@twitter_client)
      @twitter_client.expects(:user).raises(Twitter::Error::Unauthorized)

      auth = TwitterAuth.new('twitter_access_token', 'twitter_secret')
      assert_raises(Error::Unauthorized) do
        auth.create_user!
      end
    end
  end
end
