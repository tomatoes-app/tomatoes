class WelcomeController < ApplicationController
  def index
    if current_user
      @tomato         = current_user.tomatoes.build
      @tomatoes       = current_user.tomatoes_after(Time.zone.now.beginning_of_day)
      @tomatoes_count = Hash[[:day, :week, :month].map do |time_period|
        [time_period, current_user.tomatoes_after(Time.zone.now.send("beginning_of_#{time_period}")).count]
      end]
    end
  end
end
