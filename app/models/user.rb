class User
  include Mongoid::Document
  
  # authorization fields (deprecated)
  field :provider, :type => String
  field :uid,      :type => String
  field :token,    :type => String
  
  field :login,       :type => String
  field :name,        :type => String
  field :email,       :type => String
  field :gravatar_id, :type => String
  
  attr_accessible :provider, :uid, :token, :login, :name, :email, :gravatar_id
  
  embeds_many :authorizations
  has_many :tomatoes
  
  def tags
    tomatoes.collect(&:tags).flatten.inject(Hash.new(0)) do |hash, tag|
      hash[tag] += 1; hash
    end.sort do |a, b|
      b[1] <=> a[1]
    end
  end
  
  def self.find_by_omniauth(auth)
    any_of(
      {:authorizations => {
        '$elemMatch' => {
          :provider => auth['provider'],
          :uid      => auth['uid'] }}},
      {:provider => auth['provider'], :uid => auth['uid']}
    ).first
  end
  
  def self.create_with_omniauth!(auth)
    begin
      user = User.new(omniauth_attributes(auth))
      user.authorizations.build(Authorization.omniauth_attributes(auth))
      user.save!
      user
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
    
    attributes.merge!({
      name: auth['info']['name'],
      email: auth['info']['email'],
      login: auth['info']['nickname']
    }) if auth['info']

    attributes.merge!(gravatar_id: auth['extra']['raw_info']['gravatar_id']) if auth['extra'] && auth['extra']['raw_info']
    
    attributes
  end
end
