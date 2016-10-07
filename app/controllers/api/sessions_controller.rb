module Api
  class SessionsController < BaseController
    def create
      auth_provider = AuthFactory.build(params)
      user = auth_provider.find_user

      if user.nil?
        # TODO: create a new user
        raise StandardError.new('TODO: create a new user')
      end

      tomatoes_auth = user.authorizations.new(provider: 'tomatoes')
      tomatoes_auth.generate_token
      tomatoes_auth.save!

      render json: { token: tomatoes_auth.token }
    rescue Error::Unauthorized
      unauthorized 'authentication failed'
    end
  end
end
