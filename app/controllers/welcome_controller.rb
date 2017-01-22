class WelcomeController < ApplicationController
  layout 'welcome'

  def index
    if current_user
      @tomato         = current_user.tomatoes.build
      @tomatoes       = current_user.tomatoes.after(Time.zone.now.beginning_of_day)
      @tomatoes_count = current_user.tomatoes_counters
      @projects       = @tomatoes.collect(&:projects).flatten.uniq
    end
  end
end
