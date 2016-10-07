module Api
  class AuthFactory
    def self.build(params)
      case params[:provider]
      when 'github'
        GithubAuth.new(params[:access_token])
      when 'twitter'
        # TODO: support twitter provider
        raise StandardError.new('TODO: support twitter provider')
      else
        raise Error::ProviderNotSupported.new("Provider '#{provider}' not supported")
      end
    end
  end
end
