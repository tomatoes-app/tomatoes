module Leaderboard
  class OverallsController < BaseController

    private

    def collection
      OverallScore
    end
  end
end
