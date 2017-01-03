module Leaderboard
  class MonthliesController < ApplicationController
    include LeaderboardController

    private

    def collection
      MonthlyScore
    end
  end
end
