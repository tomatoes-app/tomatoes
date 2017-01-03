module Leaderboard
  class OverallsController < ApplicationController
    include LeaderboardController

    private

    def collection
      OverallScore
    end
  end
end
