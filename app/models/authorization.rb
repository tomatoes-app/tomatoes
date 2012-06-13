class Authorization
  include Mongoid::Document
  
  field :provider, :type => String
  field :uid,      :type => String
  field :token,    :type => String
  field :secret,   :type => String
  
  embedded_in :user

  def self.omniauth_attributes(auth)
    attributes = {
      provider: auth['provider'],
      uid: auth['uid'] }
    
    attributes.merge!({
      token: auth['credentials']['token'],
      secret: auth['credentials']['secret']
    }) if auth['credentials']
    
    attributes
  end
end
