module Leaderboard
  class BaseController < ApplicationController
    def show
      @leaderboard = collection.includes(:user).desc(:score).page(params[:page])
    end
  end
end
