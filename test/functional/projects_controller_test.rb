require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @user = User.create(
      :provider => "provider",
      :uid      => "uid",
      :name     => "name",
      :email    => "email",
      :login    => "login"
    )
    @project = @user.projects.create(:name => "Test project", :tag_list => "one, two")
    
    @controller.stubs(:current_user).returns(@user)
  end

  teardown do
    @user.destroy
    @project.destroy
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, project: { money_budget: @project.money_budget, name: @project.name, tags: @project.tags, time_budget: @project.time_budget }
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "should show project" do
    get :show, id: @project
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project
    assert_response :success
  end

  test "should update project" do
    put :update, id: @project, project: { money_budget: @project.money_budget, name: @project.name, tags: @project.tags, time_budget: @project.time_budget }
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end
end
