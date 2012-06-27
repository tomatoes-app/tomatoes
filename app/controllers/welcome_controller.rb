class WelcomeController < ApplicationController
  def index
    if current_user
      @tomato   = current_user.tomatoes.build
      @tomatoes = current_user.tomatoes_after(Time.zone.now.beginning_of_day)
    end
  end
end
