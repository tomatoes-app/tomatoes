class WelcomeController < ApplicationController
  layout :choose_layout

  def index
    if current_user
      @tomato         = current_user.tomatoes.build
      @tomatoes       = current_user.tomatoes_after(Time.zone.now.beginning_of_day)
      @tomatoes_count = current_user.tomatoes_counters
      @projects       = @tomatoes.collect(&:projects).flatten.uniq
    end
  end

  private

  def choose_layout
    current_user.present? ? 'application' : 'public'
  end
end
