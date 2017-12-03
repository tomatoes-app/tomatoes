require 'test_helper'

module Api
  class SessionsControllerTest < ActionController::TestCase
    setup do
      @user = User.create!(
        name: 'name',
        email: 'email@example.com'
      )
      @user.authorizations.create!(
        provider: 'github',
        uid: 'github_user_id'
      )
      @user.authorizations.create!(
        provider: 'twitter',
        uid: 'twitter_user_id'
      )

      @user_with_api_auth = User.create!(
        name: 'name',
        email: 'email@example.com'
      )
      @user_with_api_auth.authorizations.create!(
        provider: 'github',
        uid: 'github_user_with_api_auth_id'
      )
      @user_with_api_auth.authorizations.create!(
        provider: 'twitter',
        uid: 'twitter_user_with_api_auth_id'
      )
      @user_with_api_auth.authorizations.create!(
        provider: 'tomatoes',
        token: 'tomatoes_token'
      )

      @twitter_user = Twitter::User.new(
        id: 'twitter_user_id',
        name: 'Giovanni',
        screen_name: 'potomak'
      )
      @twitter_user_with_api_auth = Twitter::User.new(
        id: 'twitter_user_with_api_auth_id',
        name: 'Giovanni',
        screen_name: 'potomak'
      )
      @new_twitter_user = Twitter::User.new(
        id: 'new_twitter_user',
        name: 'Giovanni',
        screen_name: 'potomak'
      )

      @github_client = Octokit::Client.new
      @twitter_client = Twitter::REST::Client
    end

    teardown do
      User.destroy_all
    end

    test 'POST /create, '\
        'given a github access token, '\
        'associated with an existing user, '\
        'it should create a new session' do
      Octokit::Client.expects(:new).with(access_token: 'github_access_token').returns(@github_client)
      @github_client.expects(:user).returns(id: 'github_user_id')

      assert_difference('@user.reload.authorizations.count') do
        post :create, params: { provider: 'github', access_token: 'github_access_token' }
      end
      assert_response :success
      assert_equal 'application/json', @response.content_type
      assert JSON.parse(@response.body).key?('token')
    end

    test 'POST /create, '\
        'given a github access token, '\
        'associated with an existing user, '\
        'with an existing session, '\
        'it should create a new session' do
      Octokit::Client.expects(:new).with(access_token: 'github_access_token').returns(@github_client)
      @github_client.expects(:user).returns(id: 'github_user_with_api_auth_id')

      assert_difference('@user_with_api_auth.reload.authorizations.count') do
        post :create, params: { provider: 'github', access_token: 'github_access_token' }
      end
      assert_response :success
      assert_equal 'application/json', @response.content_type
      assert JSON.parse(@response.body).key?('token')
    end

    test 'POST /create, '\
        'given a github access token, '\
        'not associated with any user, '\
        'it should create a new user' do
      Octokit::Client.expects(:new).with(access_token: 'github_access_token').returns(@github_client)
      @github_client.expects(:user).returns(id: 'new_github_user_id')

      assert_difference('User.count') do
        post :create, params: { provider: 'github', access_token: 'github_access_token' }
      end
      assert_response :success
      assert_equal 'application/json', @response.content_type
      assert JSON.parse(@response.body).key?('token')
    end

    test 'POST /create, given an invalid github access token, it should return an error' do
      Octokit::Client.expects(:new).with(access_token: 'github_access_token').returns(@github_client)
      @github_client.expects(:user).raises(Octokit::Unauthorized)

      post :create, params: { provider: 'github', access_token: 'github_access_token' }
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end

    test 'POST /create, given an invalid provider, it should return an error' do
      post :create, params: { provider: 'invalid_provider' }
      assert_response :bad_request
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'provider not supported' }.to_json, @response.body)
    end

    test 'POST /create, '\
        'given a twitter access token and secret, '\
        'associated with an existing user, '\
        'it should create a new session' do
      Twitter::REST::Client.expects(:new).returns(@twitter_client)
      @twitter_client.expects(:user).returns(@twitter_user)

      assert_difference('@user.reload.authorizations.count') do
        post :create, params: { provider: 'twitter', access_token: 'twitter_access_token', secret: 'twitter_secret' }
      end
      assert_response :success
      assert_equal 'application/json', @response.content_type
      assert JSON.parse(@response.body).key?('token')
    end

    test 'POST /create, '\
        'given a twitter access token and secret, '\
        'associated with an existing user, '\
        'with an existing session, '\
        'it should create a new session' do
      Twitter::REST::Client.expects(:new).returns(@twitter_client)
      @twitter_client.expects(:user).returns(@twitter_user_with_api_auth)

      assert_difference('@user_with_api_auth.reload.authorizations.count') do
        post :create, params: { provider: 'twitter', access_token: 'twitter_access_token', secret: 'twitter_secret' }
      end
      assert_response :success
      assert_equal 'application/json', @response.content_type
      assert JSON.parse(@response.body).key?('token')
    end

    test 'POST /create, '\
        'given a twitter access token and secret, '\
        'not associated with any user, '\
        'it should create a new user' do
      Twitter::REST::Client.expects(:new).returns(@twitter_client)
      @twitter_client.expects(:user).returns(@new_twitter_user)

      assert_difference('User.count') do
        post :create, params: { provider: 'twitter', access_token: 'twitter_access_token', secret: 'twitter_secret' }
      end
      assert_response :success
      assert_equal 'application/json', @response.content_type
      assert JSON.parse(@response.body).key?('token')
    end

    test 'POST /create, given an invalid twitter access token and secret, it should return an error' do
      Twitter::REST::Client.expects(:new).returns(@twitter_client)
      @twitter_client.expects(:user).raises(Twitter::Error::Unauthorized)

      post :create, params: { provider: 'twitter', access_token: 'twitter_access_token', secret: 'twitter_secret' }
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end

    test 'DELETE /destroy, given an authenticated user, it should destroy any tomatoes session' do
      Octokit::Client.stubs(:new).returns(@github_client)
      @github_client.stubs(:user).returns(id: 'github_user_with_api_auth_id')

      post :create, params: { provider: 'github', access_token: 'github_access_token' }
      tomatoes_auth = @user_with_api_auth.reload.authorizations.where(provider: 'tomatoes').first

      assert_difference('@user_with_api_auth.reload.authorizations.count', -2) do
        delete :destroy, params: { token: tomatoes_auth.token }
      end
      assert_empty @user_with_api_auth.authorizations.where(provider: 'tomatoes')
      assert_response :no_content
    end

    test 'DELETE /destroy, given an invalid token, it should return an error' do
      delete :destroy, params: { token: 'invalid_token' }
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end
  end
end
