class RankingController < ApplicationController
  def today
    @leaderboard = Tomato.ranking_today
  end

  def this_week
    @leaderboard = Tomato.ranking_this_week
  end

  def this_month
    @leaderboard = Tomato.ranking_this_month
  end

  def all_time
    @leaderboard = Tomato.ranking
  end
end
