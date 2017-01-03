module Leaderboard
  class DailiesController < ApplicationController
    include LeaderboardController

    private

    def collection
      DailyScore
    end
  end
end
