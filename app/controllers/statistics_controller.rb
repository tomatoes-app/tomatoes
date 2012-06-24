class StatisticsController < ApplicationController
  def index
    @users        = User.count
    @tomatoes     = Tomato.count
    @first_tomato = Tomato.order_by([[:created_at, :desc]]).last || Tomato.new(:created_at => Time.now)
  end
end
