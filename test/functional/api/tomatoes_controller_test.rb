require 'test_helper'

module Api
  class TomatoesControllerTest < ActionController::TestCase
    setup do
      @user = User.create!(name: 'name', email: 'email@example.com')
      @user.authorizations.create!(provider: 'tomatoes', token: '123')
      @tomato_1 = @user.tomatoes.build
      @tomato_1.created_at = 1.hour.ago
      @tomato_1.save!
      @tomato_2 = @user.tomatoes.create!(tag_list: 'one, two')

      @other_user = User.create!
      @tomato_3 = @other_user.tomatoes.create!
    end

    teardown do
      User.destroy_all
      Tomato.destroy_all
    end

    test 'GET /index, given an invalid token, it should return an error' do
      get :index, token: 'invalid_token'
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end

    test 'GET /index, it should return current user\'s list of tomatoes' do
      get :index, token: '123'
      assert_response :success
      assert_equal 'application/json', @response.content_type
      tomatoes_ids = JSON.parse(@response.body).map { |t| t['id'] }
      assert_includes tomatoes_ids, @tomato_1.id.to_s
      assert_includes tomatoes_ids, @tomato_2.id.to_s
      assert_not_includes tomatoes_ids, @tomato_3.id.to_s
    end

    test 'GET /show, given an invalid token, it should return an error' do
      get :show, token: 'invalid_token', id: @tomato_1.id.to_s
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end

    test 'GET /show, it should return current user\'s tomato' do
      get :show, token: '123', id: @tomato_1.id.to_s
      assert_response :success
      assert_equal 'application/json', @response.content_type
      assert_equal Api::Presenter::Tomato.new(@tomato_1).to_json, @response.body
    end

    test 'GET /show, it should not return other users\' tomatoes' do
      assert_raises(Mongoid::Errors::DocumentNotFound) do
        get :show, token: '123', id: @tomato_3.id.to_s
      end
    end
  end
end
