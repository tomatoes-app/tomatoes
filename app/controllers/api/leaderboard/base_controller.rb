module Api
  module Leaderboard
    class BaseController < Api::BaseController
      include LeaderboardController

      def show
        render json: Presenter::Scores.new(@scores)
      end
    end
  end
end
