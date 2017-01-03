module Api
  module Leaderboard
    class WeekliesController < Api::Leaderboard::BaseController
      include LeaderboardController

      private

      def scope
        WeeklyScore.scoped
      end
    end
  end
end
