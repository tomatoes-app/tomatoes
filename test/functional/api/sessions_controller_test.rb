require 'test_helper'

class Api::SessionsControllerTest < ActionController::TestCase
  setup do
    @github_user = User.create!(
      name: 'name',
      email: 'email@example.com'
    )
    @github_user.authorizations.create!(
      provider: 'github',
      uid: 'github_user_id'
    )

    @github_user_with_api_auth = User.create!(
      name: 'name',
      email: 'email@example.com'
    )
    @github_user_with_api_auth.authorizations.create!(
      provider: 'github',
      uid: 'github_user_with_api_auth_id'
    )
    @github_user_with_api_auth.authorizations.create!(
      provider: 'tomatoes',
      token: 'tomatoes_token'
    )
  end

  teardown do
    @github_user.destroy
    @github_user_with_api_auth.destroy
  end

  test 'given a github access token it should create a new session' do
    github_client = Octokit::Client.new
    github_client.expects(:user).returns('id' => 'github_user_id')
    Octokit::Client.expects(:new).with(access_token: 'github_access_token').returns(github_client)

    assert_difference('@github_user.reload.authorizations.count') do
      post :create, provider: 'github', access_token: 'github_access_token'
    end
    assert_response :success
    assert_equal 'application/json', @response.content_type
    assert JSON.parse(@response.body).key?('token')
  end

  test 'given a github access token it should return an existing session' do
    github_client = Octokit::Client.new
    github_client.expects(:user).returns('id' => 'github_user_with_api_auth_id')
    Octokit::Client.expects(:new).with(access_token: 'github_access_token').returns(github_client)

    assert_difference('@github_user_with_api_auth.reload.authorizations.count') do
      post :create, provider: 'github', access_token: 'github_access_token'
    end
    assert_response :success
    assert_equal 'application/json', @response.content_type
    assert JSON.parse(@response.body).key?('token')
  end
end
