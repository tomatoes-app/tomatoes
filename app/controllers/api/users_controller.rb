module Api
  class UsersController < BaseController
    include UsersParams

    before_action :authenticate_user!

    # GET /api/user
    def show
      render json: Presenter::User.new(current_user)
    end

    # PUT /api/user
    def update
      if current_user.update_attributes(resource_params)
        render json: Presenter::User.new(current_user), location: api_user_url
      else
        render status: :unprocessable_entity, json: current_user.errors
      end
    end
  end
end
