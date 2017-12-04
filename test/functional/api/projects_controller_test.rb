require 'test_helper'

module Api
  class ProjectsControllerTest < ActionController::TestCase
    setup do
      @user = User.create!(name: 'name', email: 'email@example.com')
      @user.authorizations.create!(provider: 'tomatoes', token: '123')
      @project = @user.projects.create!(
        name: 'Test project',
        money_budget: 123,
        time_budget: 234,
        tag_list: 'one, two'
      )
      @second_project = @user.projects.create!(
        name: 'Second project',
        money_budget: 234,
        time_budget: 345,
        tag_list: 'three, four'
      )

      @other_user = User.create!
      @other_project = @other_user.projects.create!(name: 'Other project')
    end

    teardown do
      User.destroy_all
      Project.destroy_all
    end

    test 'GET /index, given an invalid token, it should return an error' do
      get :index, params: { token: 'invalid_token' }
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end

    test 'GET /index, it should return current user\'s list of projects' do
      get :index, params: { token: '123' }
      assert_response :success
      assert_equal 'application/json', @response.content_type
      parsed_response = JSON.parse(@response.body)
      projects_ids = parsed_response['projects'].map { |t| t['id'] }
      assert_includes projects_ids, @project.id.to_s
      assert_not_includes projects_ids, @other_project.id.to_s
    end

    test 'GET /index, it should return current user\'s list of projects filtered by tags' do
      get :index, params: { token: '123', tag_list: 'zero, three' }
      assert_response :success
      assert_equal 'application/json', @response.content_type
      parsed_response = JSON.parse(@response.body)
      projects_ids = parsed_response['projects'].map { |t| t['id'] }
      assert_equal projects_ids.size, 1
      assert_includes projects_ids, @second_project.id.to_s
    end

    test 'GET /show, given an invalid token, it should return an error' do
      get :show, params: { token: 'invalid_token', id: @project.id.to_s }
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end

    test 'GET /show, it should return current user\'s project' do
      get :show, params: { token: '123', id: @project.id.to_s }
      assert_response :success
      assert_equal 'application/json', @response.content_type
      assert_equal Api::Presenter::Project.new(@project).to_json, @response.body
    end

    test 'GET /show, it should not return other users\' projects' do
      assert_raises(Mongoid::Errors::DocumentNotFound) do
        get :show, params: { token: '123', id: @other_project.id.to_s }
      end
    end

    test 'POST /create, given an invalid token, it should return an error' do
      post :create, params: { token: 'invalid_token', project: { name: 'API project' } }
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end

    test 'POST /create, given valid params, it should create a project' do
      assert_difference('@user.projects.size') do
        post :create, params: {
          token: '123',
          project: {
            name: 'API project',
            tag_list: 'test',
            money_budget: 123,
            time_budget: 234
          }
        }
      end
      assert_response :created
      new_project = @user.reload.projects.order_by([%i[created_at desc]]).first
      assert_equal 'application/json', @response.content_type
      assert_equal Api::Presenter::Project.new(new_project).to_json, @response.body
      assert_match(/#{api_project_path(new_project)}/, @response.headers['Location'])
    end

    test 'POST /create, given a validation error, it should return an error' do
      assert_no_difference('@user.projects.size') do
        post :create, params: { token: '123', project: { tag_list: '' } }
      end
      assert_response :unprocessable_entity
      assert_equal 'application/json', @response.content_type
      parsed_response = JSON.parse(@response.body)
      assert_match(/can't be blank/, parsed_response['name'].first)
    end

    test 'PATCH /update, given an invalid token, it should return an error' do
      patch :update, params: { token: 'invalid_token', id: @project.id, project: { tag_list: 'three' } }
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end

    test 'PATCH /update, given valid params, it should update the project' do
      patch :update, params: {
        token: '123',
        id: @project.id,
        project: {
          name: 'API project',
          tag_list: 'three',
          money_budget: 123,
          time_budget: 234
        }
      }
      assert_response :success
      assert_equal 'application/json', @response.content_type
      @project.reload
      assert_equal Api::Presenter::Project.new(@project).to_json, @response.body
      assert_match(/#{api_project_path(@project)}/, @response.headers['Location'])
      assert_equal %w[three], @project.tags
    end

    test 'PATCH /update, given a validation error, it should return an error' do
      @controller.stubs(:current_user).returns(@user)
      projects = []
      @user.stubs(:projects).returns(projects)
      projects.stubs(:find).returns(@project)
      @project.expects(:update_attributes).returns(false)

      patch :update, params: { token: '123', id: @project.id, project: { tag_list: 'three' } }
      assert_response :unprocessable_entity
      assert_equal 'application/json', @response.content_type
    end

    test 'DELETE /destroy, given an invalid token, it should return an error' do
      delete :destroy, params: { token: 'invalid_token', id: @project.id }
      assert_response :unauthorized
      assert_equal 'application/json', @response.content_type
      assert_equal({ error: 'authentication failed' }.to_json, @response.body)
    end

    test 'DELETE /destroy, given valid params, it should destroy the project' do
      assert_difference('@user.projects.count', -1) do
        delete :destroy, params: { token: '123', id: @project.id }
      end
      assert_response :no_content
    end
  end
end
