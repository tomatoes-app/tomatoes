require 'test_helper'

class TomatoesControllerTest < ActionController::TestCase
  setup do
    # @tomato = tomatoes(:one)
    @user = User.create(
      :provider => "provider",
      :uid => "uid",
      :name => "name",
      :email => "email",
      :login => "login"
    )
    @tomato = @user.tomatoes.create(:tag_list => "one, two")
    
    @controller.stubs(:current_user).returns(@user)
  end
  
  teardown do
    @user.destroy
    @tomato.destroy
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tomatoes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tomato" do
    @tomato = @user.tomatoes.build(:tag_list => "one, two")
    
    assert_difference('Tomato.count') do
      post :create, :tomato => @tomato.attributes
    end

    assert_redirected_to root_path
  end

  test "should show tomato" do
    get :show, :id => @tomato.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @tomato.to_param
    assert_response :success
  end

  test "should update tomato" do
    put :update, :id => @tomato.to_param, :tomato => @tomato.attributes
    assert_redirected_to tomato_path(assigns(:tomato))
  end

  test "should destroy tomato" do
    assert_difference('Tomato.count', -1) do
      delete :destroy, :id => @tomato.to_param
    end

    assert_redirected_to tomatoes_path
  end
end
