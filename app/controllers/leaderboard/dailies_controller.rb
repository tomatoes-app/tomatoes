module Leaderboard
  class DailiesController < ApplicationController
    include LeaderboardController

    private

    def scope
      DailyScore.scoped
    end
  end
end
