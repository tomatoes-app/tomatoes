class WelcomeController < ApplicationController
  def index
    if current_user
      @tomato = current_user.tomatoes.build
      @tomatoes = current_user.tomatoes.order_by([[:created_at, :desc]]).group_by do |tomato|
        date = tomato.created_at
        Time.mktime(date.year, date.month, date.day)
      end
    end
  end
end
