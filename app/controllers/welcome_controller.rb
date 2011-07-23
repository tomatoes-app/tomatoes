class WelcomeController < ApplicationController
  def index
    if current_user
      @tomato = current_user.tomatoes.build
      @tomatoes = current_user.tomatoes.all
    end
  end
end
