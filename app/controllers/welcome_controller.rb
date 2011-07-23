class WelcomeController < ApplicationController
  def index
    @tomato = current_user.tomatoes.build
    @tomatoes = current_user.tomatoes.all
  end
end
