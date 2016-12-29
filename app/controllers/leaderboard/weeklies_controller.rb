module Leaderboard
  class WeekliesController < BaseController

    private

    def collection
      WeeklyScore
    end
  end
end
