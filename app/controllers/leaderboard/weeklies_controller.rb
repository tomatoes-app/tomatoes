module Leaderboard
  class WeekliesController < ApplicationController
    include LeaderboardController

    private

    def collection
      WeeklyScore
    end
  end
end
