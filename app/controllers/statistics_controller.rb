class StatisticsController < ApplicationController
  # GET /statistics
  def index
    @users        = User.count
    @tomatoes     = Tomato.count
    @first_tomato = Tomato.order_by([[:created_at, :desc]]).last || Tomato.new(:created_at => Time.now)
  end

  # GET /statistics/users_by_tomatoes.json
  def users_by_tomatoes
    respond_with_json(User.by_tomatoes(User.all))
  end

  # GET /statistics/users_by_day.json
  def users_by_day
    respond_with_json(User.by_day(User.all))
  end

  # GET /statistics/tomatoes_by_day.json
  def tomatoes_by_day
    respond_with_json(Tomato.by_day(Tomato.all))
  end
end
