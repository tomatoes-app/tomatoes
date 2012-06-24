class RankingController < ApplicationController
  def today
    Tomato.ranking_collection(Tomato.today, 'user_ranking_today')
    @leaderboard = UserRankingToday.desc(:value)
  end

  def this_week
    Tomato.ranking_collection(Tomato.this_week, 'user_ranking_this_week')
    @leaderboard = UserRankingThisWeek.desc(:value)
  end

  def this_month
    Tomato.ranking_collection(Tomato.this_month, 'user_ranking_this_month')
    @leaderboard = UserRankingThisMonth.desc(:value)
  end

  def all_time
    Tomato.ranking_collection(Tomato.all_time, 'user_ranking_all_time')
    @leaderboard = UserRankingAllTime.desc(:value)
  end
end
