class User
  include Mongoid::Document
  
  # authorization fields (deprecated)
  field :provider,    :type => String
  field :uid,         :type => String
  field :token,       :type => String
  field :login,       :type => String
  field :gravatar_id, :type => String

  field :name,      :type => String
  field :email,     :type => String
  field :image,     :type => String
  field :time_zone, :type => String
  
  # attr_accessible :provider, :uid, :token, :login, :gravatar_id
  attr_accessible :name, :email, :image, :time_zone
  
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
    logger.debug "find_by_omniauth"
    any_of(
      {:authorizations => {
        '$elemMatch' => {
          :provider => auth['provider'].to_s,
          :uid      => auth['uid'].to_s }}},
      {:provider => auth['provider'], :uid => auth['uid']}
    ).first
  end
  
  def self.create_with_omniauth!(auth)
    logger.debug "create_with_omniauth"
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

      if authorization = authorization_by_provider(auth['provider'])
        authorization.update_attributes!(Authorization.omniauth_attributes(auth))
      else
        # merge one more authorization provider
        authorizations.create!(Authorization.omniauth_attributes(auth))
      end
    rescue Exception
      raise Exception, "Cannot update user"
    end
  end
  
  def self.omniauth_attributes(auth)
    attributes = {}
    
    attributes.merge!({
      name: auth['info']['name'],
      email: auth['info']['email'],
      image: auth['info']['image']
    }) if auth['info']
    
    attributes
  end

  def authorization_by_provider(provider)
    authorizations.where(provider: provider).first
  end

  def tomatoes_after(time)
    tomatoes.where(:created_at => {'$gte' => time}).order_by([[:created_at, :desc]])
  end
end
