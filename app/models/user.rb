class User
  include Mongoid::Document
  field :provider, :type => String
  field :uid, :type => String
  field :login, :type => String
  field :name, :type => String
  field :email, :type => String
  field :gravatar_id, :type => String
  field :token, :type => String
  attr_accessible :provider, :uid, :login, :name, :email, :gravatar_id, :token
  
  has_many :tomatoes
  
  def tags
    tomatoes.collect(&:tags).flatten.inject(Hash.new(0)) do |hash, tag|
      hash[tag] += 1; hash
    end.sort do |a, b|
      b[1] <=> a[1]
    end
  end
  
  def self.find_by_omniauth(auth)
    where(:provider => auth['provider'], :uid => auth['uid']).first
  end
  
  def self.create_with_omniauth!(auth)
    begin
      create!({
        :provider => auth['provider'],
        :uid => auth['uid']
      }.merge(omniauth_attributes(auth)))
    rescue Exception
      raise Exception, "Cannot create user"
    end
  end
  
  def update_omniauth_attributes!(auth)
    begin
      update_attributes!(User.omniauth_attributes(auth))
    rescue Exception
      raise Exception, "Cannot update user"
    end
  end
  
  def self.omniauth_attributes(auth)
    attributes = {}
    
    if auth['user_info']
      attributes.merge!({
        :name => auth['user_info']['name'], # Twitter, Google, Yahoo, GitHub
        :email => auth['user_info']['email'], # Google, Yahoo, GitHub
        :login => auth['user_info']['nickname'], # GitHub
        :token => auth['credentials']['token'] # GitHub
      })
    end
    
    if auth['extra']['user_hash']
      attributes.merge!({
        :name => auth['extra']['user_hash']['name'], # Facebook
        :email => auth['extra']['user_hash']['email'], # Facebook
        :gravatar_id => auth['extra']['user_hash']['gravatar_id'] # GitHub
      })
    end
    
    attributes
  end
end
