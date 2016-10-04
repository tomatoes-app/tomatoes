require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  setup do
    @user = User.create(
      provider: 'provider',
      uid: 'uid',
      name: 'name',
      email: 'email@example.com'
    )
    @tag = 'test'

    @controller.stubs(:current_user).returns(@user)
  end

  teardown do
    @user.destroy
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:tomatoes_by_tag)
  end

  test 'should show tag' do
    get :show, id: @tag
    assert_response :success
  end
end
