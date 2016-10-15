module Api
  class UsersController < BaseController
    before_action :authenticate_user!

    def show
      render json: Presenter::User.new(current_user)
    end

    def update
      if current_user.update_attributes(resource_params)
        render json: Presenter::User.new(current_user), location: api_user_url
      else
        render status: :unprocessable_entity, json: current_user.errors
      end
    end

    private

    def resource_params
      params.require(:user).permit(
        :name,
        :email,
        :image,
        :time_zone,
        :color,
        :work_hours_per_day,
        :average_hourly_rate,
        :currency,
        :volume,
        :ticking)
    end
  end
end
