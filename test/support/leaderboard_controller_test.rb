require 'test_helper'

module LeaderboardControllerTest
  extend ActiveSupport::Concern

  included do
    setup do
      User.destroy_all
      Tomato.delete_all

      @user = User.create!(
        name: 'name',
        email: 'email@example.com'
      )
      @tomato = @user.tomatoes.create!(tag_list: 'one, two', duration: 25)
    end

    test 'should get show' do
      get :show
      assert_response :success
      assert_not_nil assigns(:scores)
      assert_not_empty assigns(:scores)
    end
  end
end
