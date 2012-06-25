class RankingsController < ApplicationController
  def index
    if %w(today this_week this_month all_time).include?(params[:time_period])
      Tomato.ranking_collection(params[:time_period].to_sym)
      @leaderboard = "UserRanking#{params[:time_period].classify}".constantize.desc(:value)
    else
      head :bad_request
    end
  end
end
