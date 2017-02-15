require 'test_helper'

module Api
  class UsersControllerTest < ActionController::TestCase
    setup do
      @user = User.create!(name: 'name', email: 'email@example.com')
      @user.authorizations.create!(provider: 'tomatoes', token: '123')

      @user_without_auths = User.create!(name: 'Nicolae', email: 'nic@example.com')
    end

    teardown do
      User.destroy_all
    end

    test 'GET /show, given a nil token, it should return an error' do
      get :show
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end

    test 'GET /show, given a blank token, it should return an error' do
      get :show, token: ''
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end

    test 'GET /show, given an invalid token, it should return an error' do
      get :show, token: 'invalid_token'
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end

    test 'GET /show, given a headr authorization token, it should return current user' do
      @request.headers['Authorization'] = '123'
      get :show
      assert_response :success
      assert_equal 'application/json', @response.content_type
      assert_equal Api::Presenter::User.new(@user).to_json, @response.body
    end

    test 'GET /show, it should return current user' do
      get :show, token: '123'
      assert_response :success
      assert_equal 'application/json', @response.content_type
      assert_equal Api::Presenter::User.new(@user).to_json, @response.body
    end

    test 'GET /show, '\
        'user time zone is set to America/New_York, '\
        'it returns the correct number of tomatoes' do
      setup_tz_test

      travel_to night_in(new_york_tz) do
        get :show, token: '123'
        assert_response :success
        assert_equal 'application/json', @response.content_type
        response_content = JSON.parse(@response.body)
        assert_equal 2, response_content['tomatoes_counters']['day']
      end
    end

    test 'GET /show, '\
        'user time zone is set to America/New_York, '\
        'request param overrides user time zone, '\
        'it returns the correct number of tomatoes' do
      setup_tz_test

      travel_to night_in(new_york_tz) do
        get :show, token: '123', time_zone: rome_tz.name
        assert_response :success
        assert_equal 'application/json', @response.content_type
        response_content = JSON.parse(@response.body)
        assert_equal 1, response_content['tomatoes_counters']['day']
      end
    end

    test 'GET /show, '\
        'user time zone is set to America/New_York, '\
        'request header overrides param and user time zone, '\
        'it returns the correct number of tomatoes' do
      setup_tz_test

      travel_to night_in(new_york_tz) do
        @request.headers['Time-Zone'] = rome_tz.name
        get :show, token: '123', time_zone: new_york_tz.name
        assert_response :success
        assert_equal 'application/json', @response.content_type
        response_content = JSON.parse(@response.body)
        assert_equal 1, response_content['tomatoes_counters']['day']
      end
    end

    test 'PATCH /update, given an invalid token, it should return an error' do
      patch :update, token: 'invalid_token', user: { name: 'Foo' }
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end

    test 'PATCH /update, given valid params, it should update current user' do
      patch :update, token: '123', user: { name: 'Foo' }
      assert_response :success
      assert_equal 'application/json', @response.content_type
      @user.reload
      assert_equal Api::Presenter::User.new(@user).to_json, @response.body
      assert_match(/#{api_user_path}/, @response.headers['Location'])
      assert_equal 'Foo', @user.name
    end

    test 'PATCH /update, given a validation error, it should return an error' do
      @controller.stubs(:current_user).returns(@user)
      @user.expects(:update_attributes).returns(false)

      patch :update, token: '123', user: { name: 'Foo' }
      assert_response :unprocessable_entity
      assert_equal 'application/json', @response.content_type
    end

    private

    def new_york_tz
      ActiveSupport::TimeZone['America/New_York']
    end

    def rome_tz
      ActiveSupport::TimeZone['Europe/Rome']
    end

    def morning_in(tz)
      tz.now.change(hour: 10)
    end

    def night_in(tz)
      tz.now.change(hour: 22)
    end

    def setup_tz_test
      @user.update_attribute(:time_zone, new_york_tz.name)

      travel_to morning_in(new_york_tz) do
        @user.tomatoes.create!
      end

      travel_to night_in(new_york_tz) do
        @user.tomatoes.create!
      end
    end
  end
end
