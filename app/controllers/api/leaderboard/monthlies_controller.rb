module Api
  module Leaderboard
    class MonthliesController < Api::Leaderboard::BaseController
      include LeaderboardController

      private

      def scope
        MonthlyScore.scoped
      end
    end
  end
end
