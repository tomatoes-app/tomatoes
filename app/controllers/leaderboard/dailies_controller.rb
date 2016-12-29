module Leaderboard
  class DailiesController < BaseController

    private

    def collection
      DailyScore
    end
  end
end
