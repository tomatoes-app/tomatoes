require 'test_helper'

class TomatoesControllerTest < ActionController::TestCase
  setup do
    # @tomato = tomatoes(:one)
    @user = User.create(
      provider: 'provider',
      uid: 'uid',
      name: 'name',
      email: 'email@example.com'
    )
    @tomato = @user.tomatoes.create(tag_list: 'one, two', created_at: Time.zone.now - 1.day)

    @controller.stubs(:current_user).returns(@user)
  end

  teardown do
    @tomato.destroy
    @user.destroy
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:tomatoes)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create tomato' do
    assert_difference('Tomato.count') do
      post :create, params: { tomato: { tag_list: '' } }
    end

    assert_redirected_to root_path
  end

  test 'should show tomato' do
    get :show, params: { id: @tomato.to_param }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @tomato.to_param }
    assert_response :success
  end

  test 'should update tomato' do
    assert_redirected_to tomato_path(assigns(:tomato))
    put :update, params: { id: @tomato.to_param, tomato: { tag_list: '' } }
  end

  test 'should destroy tomato' do
    assert_difference('Tomato.count', -1) do
      delete :destroy, params: { id: @tomato.to_param }
    end

    assert_redirected_to tomatoes_path
  end

  test 'should get by_day' do
    get :by_day, params: { user_id: @user.id, format: :json }
    assert_response :success
  end

  test 'should get by_hour' do
    get :by_day, params: { user_id: @user.id, format: :json }
    assert_response :success
  end
end
