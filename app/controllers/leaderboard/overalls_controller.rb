module Leaderboard
  class OverallsController < ApplicationController
    include LeaderboardController

    private

    def scope
      OverallScore.scoped
    end
  end
end
