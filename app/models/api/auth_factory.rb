module Api
  class AuthFactory
    def self.build(params)
      case params[:provider]
      when 'github'
        GithubAuth.new(params[:access_token])
      when 'twitter'
        TwitterAuth.new(params[:access_token], params[:secret])
      else
        raise Error::ProviderNotSupported.new("Provider '#{params[:provider]}' not supported")
      end
    end
  end
end
