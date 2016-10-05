module API
  class SessionController < API::BaseController
    def github_create
      begin
        client = Octokit::Client.new(:access_token => params[:access_token])
        github_uid = client.user.try(:[], 'id')
        user = User.where(provider: 'github', uid: github_uid).first()

        if user.nil?
          # TODO: create a new user
          raise StandardError('TODO: create a new user')
        end

        tomato_auth = Authorization.where(provider: 'tomatoes', uid: user.uid).first()
        if tomato_auth.nil?
          tomato_auth = Authorization.new(provider: 'tomatoes', uid: user.uid)
        end
        tomato_auth.api_authorize
        tomato_auth.save!
      rescue => err
        Rails.logger.error("Cannot log user in using Github: #{err}")
        unauthorized('authentication failed')
      end
    end
  end
end
