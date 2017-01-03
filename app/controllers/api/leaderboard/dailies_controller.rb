module Api
  module Leaderboard
    class DailiesController < Api::Leaderboard::BaseController
      include LeaderboardController

      private

      def scope
        DailyScore.scoped
      end
    end
  end
end
