module Api
  class TwitterAuth
    def initialize(access_token, secret)
      @access_token = access_token
      @secret = secret
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key = TWITTER['consumer_key']
        config.consumer_secret = TWITTER['consumer_secret']
        config.access_token = @access_token
        config.access_token_secret = @secret
      end
    end

    def find_user
      User.find_by_auth_provider(provider: 'twitter', uid: twitter_user.id)
    end

    def create_user!
      user = User.new(user_attributes)
      user.authorizations.build(auth_attributes)
      user.save!
      user
    end

    private

    def twitter_user
      @twitter_user ||= @client.user
    rescue Twitter::Error::Unauthorized => err
      error_message = "Cannot log user in using Twitter: #{err}"
      Rails.logger.error(error_message)
      raise Error::Unauthorized.new(error_message)
    end

    def user_attributes
      {
        name: twitter_user.name,
        image: twitter_user.profile_image_uri_https.to_s
      }
    end

    def auth_attributes
      {
        provider: 'twitter',
        uid: twitter_user.id,
        token: @access_token,
        secret: @secret,
        nickname: twitter_user.screen_name,
        image: twitter_user.profile_image_uri_https.to_s
      }
    end
  end
end
