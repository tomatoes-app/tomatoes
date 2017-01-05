module Leaderboard
  class MonthliesController < ApplicationController
    include LeaderboardController

    private

    def scope
      MonthlyScore.scoped
    end
  end
end
