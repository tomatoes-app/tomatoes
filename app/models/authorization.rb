class Authorization
  include Mongoid::Document
  
  field :provider, :type => String
  field :uid,      :type => String
  field :token,    :type => String
  field :secret,   :type => String
  field :nickname, :type => String
  field :image,    :type => String
  
  embedded_in :user

  def self.omniauth_attributes(auth)
    attributes = {
      provider: auth['provider'],
      uid: auth['uid'] }
    
    attributes.merge!({
      token: auth['credentials']['token'],
      secret: auth['credentials']['secret']
    }) if auth['credentials']

    attributes.merge!({
      nickname: auth['info']['nickname'],
      image: omniauth_image(auth)
    }) if auth['info']
    
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
end
