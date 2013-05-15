class WelcomeController < ApplicationController
  layout Proc.new { |controller| controller.user_signed_in? ? 'application' : 'public' }

  def index
    if current_user
      @tomato         = current_user.tomatoes.build
      @tomatoes       = current_user.tomatoes_after(Time.zone.now.beginning_of_day)
      @tomatoes_count = current_user.tomatoes_counters
      @projects       = @tomatoes.collect(&:projects).flatten.uniq
    end
  end
end
