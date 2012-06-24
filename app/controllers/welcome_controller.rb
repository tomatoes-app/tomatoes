class WelcomeController < ApplicationController
  def index
    if current_user
      @tomato = current_user.tomatoes.build
      @tomatoes = current_user.tomatoes.where(:created_at => {'$gte' => Time.zone.now.beginning_of_day}).order_by([[:created_at, :desc]])
    end

    [:all_time, :day, :week, :month].each do |type|
      Tomato.ranking_collection(type)
    end

    @day_leaderboard      = UserRankingDay.desc(:value).slice(0, 10)
    @week_leaderboard     = UserRankingWeek.desc(:value).slice(0, 10)
    @month_leaderboard    = UserRankingMonth.desc(:value).slice(0, 10)
    @all_time_leaderboard = UserRankingAllTime.desc(:value).slice(0, 10)
  end
end
