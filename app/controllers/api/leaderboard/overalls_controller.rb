module Api
  module Leaderboard
    class OverallsController < Api::Leaderboard::BaseController
      include LeaderboardController

      private

      def scope
        OverallScore.scoped
      end
    end
  end
end
