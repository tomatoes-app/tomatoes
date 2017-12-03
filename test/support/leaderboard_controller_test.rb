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
      @tomato = @user.tomatoes.create!(tag_list: 'one, two')
    end

    test 'should get show' do
      get :show
      assert_response :success
      assert response.body.include? @user.name
    end
  end
end
