class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Chartable

  DEFAULT_COLOR = '#000000'
  
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
  field :color,     :type => String
  
  # attr_accessible :provider, :uid, :token, :login, :gravatar_id
  attr_accessible :name, :email, :image, :time_zone, :color

  validates_format_of :color, with: /\A#[A-Fa-f0-9]{6}\Z/, allow_blank: true
  
  embeds_many :authorizations
  has_many :tomatoes

  index 'authorizations.uid'
  index 'authorizations.provider'

  has_merit
  
  def self.find_by_omniauth(auth)
    any_of(
      {:authorizations => {
        '$elemMatch' => {
          :provider => auth['provider'].to_s,
          :uid      => auth['uid'].to_s }}},
      {:provider => auth['provider'], :uid => auth['uid']}
    ).first
  end
  
  def self.create_with_omniauth!(auth)
    user = User.new(omniauth_attributes(auth))
    user.authorizations.build(Authorization.omniauth_attributes(auth))
    user.save!
    user
  end
  
  def update_omniauth_attributes!(auth)
    update_attributes!(User.omniauth_attributes(auth))

    if authorization = authorization_by_provider(auth['provider'])
      authorization.update_attributes!(Authorization.omniauth_attributes(auth))
    else
      # merge one more authorization provider
      authorizations.create!(Authorization.omniauth_attributes(auth))
    end
  end
  
  def self.omniauth_attributes(auth)
    attributes = {}
    
    attributes.merge!({
      name:  auth['info']['name'],
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

  def self.by_tomatoes(users)
    to_tomatoes_bars(users) do |users_by_tomatoes|
      users_by_tomatoes ? users_by_tomatoes.size : 0
    end
  end

  def self.by_day(users)
    # NOTE: first 1687 users lack of created_at value
    users_count = 1687

    to_lines(users) do |users_by_day|
      users_count += users_by_day ? users_by_day.size : 0
    end
  end

  def granted?(name, level)
    badges.select do |badge|
      name == badge.name && badge.level >= level
    end.size > 0
  end

  def color
    color_value = read_attribute(:color)
    color_value && !color_value.empty? ? color_value : User::DEFAULT_COLOR
  end
end
