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
    @user.tomatoes.create(tags: [@tag])

    @controller.stubs(:current_user).returns(@user)
  end

  teardown do
    @user.destroy
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert response.body.include? @tag
  end

  test 'should show tag' do
    get :show, params: { id: @tag }
    assert_response :success
    assert response.body.include? @tag
  end

  test 'should route tag with id that includes special characters' do
    assert_routing(
      '/tags/tag...',
      controller: 'tags',
      action: 'show',
      id: 'tag...'
    )
  end
end
