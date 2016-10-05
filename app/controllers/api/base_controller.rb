module API
  class BaseController < ActionController::Base
    skip_before_action :verify_authenticity_token
  end
end
