require 'securerandom'

class Authorization
  include Mongoid::Document

  PROVIDER_GITHUB = 'github'
  PROVIDER_TWITTER = 'twitter'
  PROVIDER_API = 'tomatoes'
  EXTERNAL_PROVIDERS = [PROVIDER_GITHUB, PROVIDER_TWITTER]
  INTERNAL_PROVIDERS = [PROVIDER_API]

  field :provider, type: String
  field :uid,      type: String
  field :token,    type: String
  field :secret,   type: String
  field :nickname, type: String
  field :image,    type: String

  embedded_in :user

  scope :external_providers, -> { nin(provider: INTERNAL_PROVIDERS) }

  def self.omniauth_attributes(auth)
    attributes = {
      provider: auth['provider'],
      uid: auth['uid'] }

    if auth['credentials']
      attributes[:token] = auth['credentials']['token']
      attributes[:secret] = auth['credentials']['secret']
    end

    if auth['info']
      attributes[:nickname] = auth['info']['nickname']
      attributes[:image] = omniauth_image(auth)
    end

    attributes
  end

  def self.omniauth_image(auth)
    case auth['provider']
    when PROVIDER_GITHUB
      auth['extra']['raw_info']['avatar_url'] if auth['extra'] && auth['extra']['raw_info']
    when PROVIDER_TWITTER
      auth['info']['image'] if auth['info']
    end
  end

  def url
    "http://#{provider}.com/#{nickname}"
  end

  def generate_token
    self.token = SecureRandom.hex
  end
end
