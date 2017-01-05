require 'test_helper'

module Api
  module LeaderboardControllerTest
    extend ActiveSupport::Concern

    included do
      setup do
        DailyScore.destroy_all
        WeeklyScore.destroy_all
        MonthlyScore.destroy_all
        OverallScore.destroy_all

        User.destroy_all
        Tomato.delete_all

        @user = User.create!(name: 'name')
        @user.tomatoes.create!
      end

      test 'should get show' do
        get :show
        assert_response :success
        assert_equal 'application/json', @response.content_type
        parsed_response = JSON.parse(@response.body)
        user_ids = parsed_response['scores'].map { |t| t['user']['id'] }
        assert_includes user_ids, @user.id.to_s
      end
    end
  end
end
