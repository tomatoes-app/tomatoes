module Api
  class TomatoesController < BaseController
    include TomatoesParams

    before_action :authenticate_user!
    before_action :find_tomato, only: %i[show update destroy]

    # GET /api/tomatoes
    def index
      @tomatoes = current_user.tomatoes
      begin
        @tomatoes = @tomatoes.after(from) if from
        @tomatoes = @tomatoes.before(to) if to
      rescue ArgumentError => bad_arg
        render status: :bad_request, json: { error: bad_arg.message }
        return
      end
      @tomatoes = @tomatoes.order_by([%i[created_at desc], %i[_id desc]]).page params[:page]

      render json: Presenter::Tomatoes.new(@tomatoes)
    end

    # GET /api/tomatoes/1
    def show
      render json: Presenter::Tomato.new(@tomato)
    end

    # POST /api/tomatoes
    def create
      @tomato = current_user.tomatoes.build(resource_params)

      if @tomato.save
        render status: :created, json: Presenter::Tomato.new(@tomato), location: api_tomato_url(@tomato)
      else
        render status: :unprocessable_entity, json: @tomato.errors
      end
    end

    # PUT /api/tomatoes/1
    def update
      if @tomato.update_attributes(resource_params)
        render json: Presenter::Tomato.new(@tomato), location: api_tomato_url(@tomato)
      else
        render status: :unprocessable_entity, json: @tomato.errors
      end
    end

    # DELETE /api/tomatoes/1
    def destroy
      @tomato.destroy

      head :no_content
    end

    private

    def from
      @from ||= Time.zone.parse(params[:from].to_s)
    rescue ArgumentError => err
      raise(ArgumentError, "invalid from: #{err.message}")
    end

    def to
      @to ||= Time.zone.parse(params[:to].to_s)
    rescue ArgumentError => err
      raise(ArgumentError, "invalid to: #{err.message}")
    end

    def find_tomato
      @tomato = current_user.tomatoes.find(params[:id])
    end
  end
end
