module Leaderboard
  class WeekliesController < ApplicationController
    include LeaderboardController

    private

    def scope
      WeeklyScore.scoped
    end
  end
end
