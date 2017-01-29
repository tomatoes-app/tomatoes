module Api
  class AuthFactory
    def self.build(params)
      case params[:provider]
      when Authorization::PROVIDER_GITHUB
        GithubAuth.new(params[:access_token])
      when Authorization::PROVIDER_TWITTER
        TwitterAuth.new(params[:access_token], params[:secret])
      else
        raise Error::ProviderNotSupported.new("Provider '#{params[:provider]}' not supported")
      end
    end
  end
end
