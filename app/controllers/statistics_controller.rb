class StatisticsController < ApplicationController
  # GET /statistics
  def index
    @users        = User.count
    @tomatoes     = Tomato.count
    @first_tomato = Tomato.order_by([[:created_at, :desc]]).last || Tomato.new(:created_at => Time.now)
  end

  # GET /statistics/users_by_tomatoes.json
  def users_by_tomatoes
    respond_to do |format|
      format.json { render :json => User.users_by_tomatoes }
    end
  end

  # GET /statistics/users_by_time.json
  def users_by_time
    respond_to do |format|
      format.json { render :json => User.users_by_time }
    end
  end

  # GET /statistics/tomatoes_by_time.json
  def tomatoes_by_time
    respond_to do |format|
      format.json { render :json => Tomato.tomatoes_by_time }
    end
  end
end
