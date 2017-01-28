class StatisticsController < ApplicationController
  # GET /statistics
  def index
    @users        = User.count
    @tomatoes     = Tomato.count
    @first_tomato = Tomato.order_by([[:created_at, :desc]]).last || Tomato.new(created_at: Time.now)
  end

  # GET /statistics/users_by_tomatoes.json
  def users_by_tomatoes
    respond_with_json do
      Rails.cache.fetch('users_by_tomatoes', expires_in: 1.day) do
        User.by_tomatoes(User.all)
      end
    end
  end

  # GET /statistics/total_users_by_day.json
  def total_users_by_day
    respond_with_json do
      Rails.cache.fetch('total_users_by_day', expires_in: 1.day) do
        User.total_by_day(User.excludes(created_at: nil))
      end
    end
  end

  # GET /statistics/users_by_day.json
  def users_by_day
    respond_with_json do
      Rails.cache.fetch('users_by_day', expires_in: 1.day) do
        User.by_day(User.excludes(created_at: nil))
      end
    end
  end

  # GET /statistics/tomatoes_by_day.json
  def tomatoes_by_day
    tomatoes_count = 0

    respond_with_json do
      Rails.cache.fetch('tomatoes_by_day', expires_in: 1.day) do
        Tomato.by_day(Tomato.all) do |tomatoes_by_day|
          tomatoes_count += tomatoes_by_day.try(:size).to_i
        end
      end
    end
  end
end
