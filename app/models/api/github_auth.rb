module Api
  class GithubAuth
    def initialize(access_token)
      @client = Octokit::Client.new(access_token: access_token)
    end

    def find_user
      github_uid = @client.user.try(:[], 'id')
      User.find_by_auth_provider(provider: 'github', uid: github_uid)
    rescue Octokit::Unauthorized => err
      error_message = "Cannot log user in using GitHub: #{err}"
      Rails.logger.error(error_message)
      raise Error::Unauthorized.new(error_message)
    end
  end
end
