class Api::SessionsController < Api::BaseController
  def create
    begin
      client = Octokit::Client.new(access_token: params[:access_token])
      github_uid = client.user.try(:[], 'id')
      user = User.find_by_auth_provider(provider: 'github', uid: github_uid)

      if user.nil?
        # TODO: create a new user
        raise StandardError('TODO: create a new user')
      end

      tomatoes_auth = user.authorizations.new(provider: 'tomatoes')
      tomatoes_auth.generate_token
      tomatoes_auth.save!

      render json: { token: tomatoes_auth.token }
    rescue => err
      Rails.logger.error("Cannot log user in using GitHub: #{err}")
      unauthorized('authentication failed')
    end
  end
end
