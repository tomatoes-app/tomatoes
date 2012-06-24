class RankingController < ApplicationController
  def today
    Tomato.ranking_collection(:day)
    @leaderboard = UserRankingDay.desc(:value)
  end

  def this_week
    Tomato.ranking_collection(:week)
    @leaderboard = UserRankingWeek.desc(:value)
  end

  def this_month
    Tomato.ranking_collection(:month)
    @leaderboard = UserRankingMonth.desc(:value)
  end

  def all_time
    Tomato.ranking_collection(:all_time)
    @leaderboard = UserRankingAllTime.desc(:value)
  end
end
