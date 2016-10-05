module API
  class BaseController < ActionController::Base
    skip_before_action :verify_authenticity_token

    private

    def unauthorized(reason)
      render json: {error: reason}
    end
  end
end
