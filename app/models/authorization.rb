require 'securerandom'

class Authorization
  include Mongoid::Document

  field :provider, type: String
  field :uid,      type: String
  field :token,    type: String
  field :secret,   type: String
  field :nickname, type: String
  field :image,    type: String

  embedded_in :user

  scope :external_providers, -> { where('provider.ne': 'tomatoes') }

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
    when 'github'
      auth['extra']['raw_info']['avatar_url'] if auth['extra'] && auth['extra']['raw_info']
    when 'twitter'
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
