module Api
  class TomatoesController < BaseController
    before_action :authenticate_user!
    before_action :find_tomato, only: [:show, :update, :destroy]

    def index
      @tomatoes = current_user.tomatoes.order_by([[:created_at, :desc], [:_id, :desc]]).page params[:page]

      render json: Presenter::Tomatoes.new(@tomatoes)
    end

    def show
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
      if @tomato.update_attributes(resource_params)
        render json: Presenter::Tomato.new(@tomato), location: api_tomato_url(@tomato)
      else
        render status: :unprocessable_entity, json: @tomato.errors
      end
    end

    def destroy
      @tomato.destroy

      head :no_content
    end

    private

    def find_tomato
      @tomato = current_user.tomatoes.find(params[:id])
    end

    def resource_params
      params.require(:tomato).permit(:tag_list)
    end
  end
end
