require 'test_helper'

module Api
  class TomatoesControllerTest < ActionController::TestCase
    setup do
      @user = User.create!(name: 'name', email: 'email@example.com')
      @user.authorizations.create!(provider: 'tomatoes', token: '123')
      @tomato1 = @user.tomatoes.build
      @tomato1.created_at = 2.hours.ago
      @tomato1.save!
      @tomato2 = @user.tomatoes.build(tag_list: 'one, two')
      @tomato2.created_at = 1.hour.ago
      @tomato2.save!

      @other_user = User.create!
      @tomato3 = @other_user.tomatoes.create!
    end

    teardown do
      User.destroy_all
      Tomato.delete_all
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
      parsed_response = JSON.parse(@response.body)
      tomatoes_ids = parsed_response['tomatoes'].map { |t| t['id'] }
      assert_includes tomatoes_ids, @tomato1.id.to_s
      assert_includes tomatoes_ids, @tomato2.id.to_s
      assert_not_includes tomatoes_ids, @tomato3.id.to_s
    end

    test 'GET /show, given an invalid token, it should return an error' do
      get :show, token: 'invalid_token', id: @tomato1.id.to_s
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end

    test 'GET /show, it should return current user\'s tomato' do
      get :show, token: '123', id: @tomato1.id.to_s
      assert_response :success
      assert_equal 'application/json', @response.content_type
      assert_equal Api::Presenter::Tomato.new(@tomato1).to_json, @response.body
    end

    test 'GET /show, it should not return other users\' tomatoes' do
      assert_raises(Mongoid::Errors::DocumentNotFound) do
        get :show, token: '123', id: @tomato3.id.to_s
      end
    end

    test 'POST /create, given an invalid token, it should return an error' do
      post :create, token: 'invalid_token', tomato: { tag_list: 'one, two' }
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end

    test 'POST /create, given valid params, it should create a tomato' do
      assert_difference('@user.tomatoes.size') do
        post :create, token: '123', tomato: { tag_list: 'one, two' }
      end
      assert_response :created
      new_tomato = @user.reload.tomatoes.order_by([[:created_at, :desc]]).first
      assert_equal 'application/json', @response.content_type
      assert_equal Api::Presenter::Tomato.new(new_tomato).to_json, @response.body
      assert_match(/#{api_tomato_path(new_tomato)}/, @response.headers['Location'])
    end

    test 'POST /create, given a validation error, it should return an error' do
      @user.tomatoes.create!

      assert_no_difference('@user.tomatoes.size') do
        # this request should fail because another tomato has been created
        # less than 25 minutes ago
        post :create, token: '123', tomato: { tag_list: 'one, two' }
      end
      assert_response :unprocessable_entity
      assert_equal 'application/json', @response.content_type
      parsed_response = JSON.parse(@response.body)
      assert_match(/Must not overlap saved tomaotes/, parsed_response['base'].first)
    end

    test 'POST /create, with bad parameters, it should return a bad request error' do
      @user.tomatoes.create!

      assert_no_difference('@user.tomatoes.size') do
        # this request should fail because no tomato param
        # has been given
        post :create, token: '123', pachino: { tag_list: 'one, two' }
      end
      assert_response :bad_request
      assert_equal 'application/json', @response.content_type
      parsed_response = JSON.parse(@response.body)
      assert_match('tomato', parsed_response['missing_param'])
    end

    test 'PATCH /update, given an invalid token, it should return an error' do
      patch :update, token: 'invalid_token', id: @tomato1.id, tomato: { tag_list: 'three' }
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end

    test 'PATCH /update, given valid params, it should update the tomato' do
      patch :update, token: '123', id: @tomato1.id, tomato: { tag_list: 'three' }
      assert_response :success
      assert_equal 'application/json', @response.content_type
      @tomato1.reload
      assert_equal Api::Presenter::Tomato.new(@tomato1).to_json, @response.body
      assert_match(/#{api_tomato_path(@tomato1)}/, @response.headers['Location'])
      assert_equal %w(three), @tomato1.tags
    end

    test 'PATCH /update, given a validation error, it should return an error' do
      @controller.stubs(:current_user).returns(@user)
      tomatoes = []
      @user.stubs(:tomatoes).returns(tomatoes)
      tomatoes.stubs(:find).returns(@tomato1)
      @tomato1.expects(:update_attributes).returns(false)

      patch :update, token: '123', id: @tomato1.id, tomato: { tag_list: 'three' }
      assert_response :unprocessable_entity
      assert_equal 'application/json', @response.content_type
    end

    test 'DELETE /destroy, given an invalid token, it should return an error' do
      delete :destroy, token: 'invalid_token', id: @tomato1.id
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end

    test 'DELETE /destroy, given valid params, it should destroy the tomato' do
      assert_difference('@user.tomatoes.count', -1) do
        delete :destroy, token: '123', id: @tomato1.id
      end
      assert_response :no_content
    end
  end
end
