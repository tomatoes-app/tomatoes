module Api
  class SessionsController < BaseController
    before_action :authenticate_user!, only: :destroy

    # POST /api/session
    def create
      auth_provider = AuthFactory.build(params)
      user = auth_provider.find_user
      user ||= auth_provider.create_user!

      tomatoes_auth = user.authorizations.build(provider: 'tomatoes')
      tomatoes_auth.generate_token
      tomatoes_auth.save!

      render json: { token: tomatoes_auth.token }
    rescue Error::ProviderNotSupported
      bad_request 'provider not supported'
    rescue Error::Unauthorized
      unauthorized 'authentication failed'
    end

    # DELETE /api/session
    def destroy
      @current_user.authorizations.where(provider: 'tomatoes').destroy_all

      head :no_content
    end
  end
end
