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

    def create
      @tomato = current_user.tomatoes.build(resource_params)

      if @tomato.save
        render status: :created, json: Presenter::Tomato.new(@tomato), location: api_tomato_url(@tomato)
      else
        render status: :unprocessable_entity, json: @tomato.errors
      end
    end

    def update
      @tomato = current_user.tomatoes.find(params[:id])

      if @tomato.update_attributes(resource_params)
        render json: Presenter::Tomato.new(@tomato), location: api_tomato_url(@tomato)
      else
        render status: :unprocessable_entity, json: @tomato.errors
      end
    end

    private

    def resource_params
      params.require(:tomato).permit(:tag_list)
    end
  end
end
