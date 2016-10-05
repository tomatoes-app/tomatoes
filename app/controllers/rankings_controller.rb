class RankingsController < ApplicationController
  def index
    if %w(today this_week this_month all_time).include?(params[:time_period])
      @cache_expiration = expires_in(params[:time_period])
      @leaderboard = Kaminari.paginate_array(cached_leaderboard).page(params[:page])
    else
      not_found
    end
  end

  protected

  def cached_leaderboard
    Rails.cache.fetch([:user_ranking, params[:time_period]], expires_in: @cache_expiration) do
      Tomato.ranking_collection(params[:time_period].to_sym).entries
      ranking_collection(params[:time_period]).desc(:value).to_a
    end
  end

  def expires_in(time_period)
    case time_period
    when 'today'
      30.minutes
    else
      1.day
    end
  end

  def ranking_collection(time_period)
    "UserRanking#{time_period.classify}".constantize
  end
end
