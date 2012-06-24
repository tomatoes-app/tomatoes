class WelcomeController < ApplicationController
  def index
    if current_user
      @tomato = current_user.tomatoes.build
      @tomatoes = current_user.tomatoes.where(:created_at => {'$gte' => Time.zone.now.beginning_of_day}).order_by([[:created_at, :desc]])
    end
  end
end
