class WelcomeController < ApplicationController
  def index
    if current_user
      @tomato = current_user.tomatoes.build
      @tomatoes = current_user.tomatoes.order_by([[:created_at, :desc]]).group_by do |tomato|
        tomato.created_at.strftime("%A, %B %e")
      end
    end
  end
end
