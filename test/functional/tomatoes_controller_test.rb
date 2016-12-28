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
    @tomato = @user.tomatoes.build(tag_list: 'one, two')

    assert_difference('Tomato.count') do
      post :create, tomato: @tomato.attributes
    end

    assert_redirected_to root_path
  end

  test 'should show tomato' do
    get :show, id: @tomato.to_param
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @tomato.to_param
    assert_response :success
  end

  test 'should update tomato' do
    put :update, id: @tomato.to_param, tomato: @tomato.attributes
    assert_redirected_to tomato_path(assigns(:tomato))
  end

  test 'should destroy tomato' do
    assert_difference('Tomato.count', -1) do
      delete :destroy, id: @tomato.to_param
    end

    assert_redirected_to tomatoes_path
  end

  test 'should get by_day' do
    get :by_day, user_id: @user.id, format: :json
    assert_response :success
  end

  test 'should get by_hour' do
    get :by_day, user_id: @user.id, format: :json
    assert_response :success
  end
end
