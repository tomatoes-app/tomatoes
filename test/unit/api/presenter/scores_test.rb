require 'test_helper'

module Api
  module Presenter
    class ScoresTest < ActiveSupport::TestCase
      setup do
        user = ::User.create!
        user.tomatoes.create!
        @scores = DailyScore.where(uid: user._id).includes(:user).desc(:score).page
      end

      teardown do
        ::Tomato.delete_all
        ::User.destroy_all
      end

      test '#as_json should include scores and pagination data' do
        presenter = Api::Presenter::Scores.new(@scores)

        assert_equal 1, presenter.as_json[:scores].size
        assert_equal({
                       current_page: 1,
                       total_pages: 1,
                       total_count: 1
                     }, presenter.as_json[:pagination])
      end
    end
  end
end
