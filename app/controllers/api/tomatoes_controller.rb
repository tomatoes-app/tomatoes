module Api
  class TomatoesController < BaseController
    before_action :authenticate_user!

    def index
      @tomatoes = current_user.tomatoes.order_by([[:created_at, :desc]]).page params[:page]

      render json: Presenter::Tomatoes.new(@tomatoes)
    end

    def show
      @tomato = current_user.tomatoes.find(params[:id])

      render json: Presenter::Tomato.new(@tomato)
    end
  end
end
