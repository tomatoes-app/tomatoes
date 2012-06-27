class RankingsController < ApplicationController
  def index
    if %w(today this_week this_month all_time).include?(params[:time_period])
      @leaderboard = Rails.cache.fetch("user_ranking_#{params[:time_period]}", :expires_in => expires_in(params[:time_period])) do
        Tomato.ranking_collection(params[:time_period].to_sym)
        ranking_collection(params[:time_period]).where(:value.gt => 0).desc(:value)
      end
    else
      head :bad_request
    end
  end

  protected

  def expires_in(time_period)
    case time_period
    when 'today'
      1.hour
    else
      1.day
    end
  end

  def ranking_collection(time_period)
    "UserRanking#{time_period.classify}".constantize
  end
end
