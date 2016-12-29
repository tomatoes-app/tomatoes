module Leaderboard
  class MonthliesController < BaseController

    private

    def collection
      MonthlyScore
    end
  end
end
