require 'test_helper'

module Leaderboard
  module BaseControllerTest
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
        assert_not_nil assigns(:scores)
        assert_not_empty assigns(:scores)
      end
    end
  end
end
