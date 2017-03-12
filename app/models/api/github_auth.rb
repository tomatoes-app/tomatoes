module Api
  class GithubAuth
    def initialize(access_token)
      @access_token = access_token
      @client = Octokit::Client.new(access_token: access_token)
    end

    def find_user
      User.find_by_auth_provider(provider: Authorization::PROVIDER_GITHUB, uid: github_user[:id].to_s)
    end

    def create_user!
      user = User.new(user_attributes)
      user.authorizations.build(auth_attributes)
      user.save!
      user
    end

    private

    def github_user
      @github_user ||= @client.user
    rescue Octokit::Unauthorized => err
      error_message = "Cannot log user in using GitHub: #{err}"
      Rails.logger.error(error_message)
      raise Error::Unauthorized, error_message
    end

    def user_attributes
      {
        name: github_user[:name],
        email: github_user[:email],
        image: github_user[:avatar_url]
      }
    end

    def auth_attributes
      {
        provider: Authorization::PROVIDER_GITHUB,
        uid: github_user[:id],
        token: @access_token,
        nickname: github_user[:login],
        image: github_user[:avatar_url]
      }
    end
  end
end
