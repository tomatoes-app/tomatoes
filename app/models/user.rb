# encoding: UTF-8

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Chartable
  include Workable

  CURRENCIES = {
    'USD' => '$',
    'EUR' => '€',
    'JPY' => '¥',
    'GBP' => '£',
    'CHF' => 'Fr.'
  }

  DEFAULT_COLOR    = '#000000'
  DEFAULT_CURRENCY = 'USD'
  
  # authorization fields (deprecated)
  field :provider,    :type => String
  field :uid,         :type => String
  field :token,       :type => String
  field :gravatar_id, :type => String

  field :name,      :type => String
  field :email,     :type => String
  field :image,     :type => String
  field :time_zone, :type => String
  field :color,     :type => String

  field :work_hours_per_day,  :type => Integer
  field :average_hourly_rate, :type => Float
  field :currency,            :type => String
  
  # attr_accessible :provider, :uid, :token, :gravatar_id
  attr_accessible :name, :email, :image, :time_zone, :color, :work_hours_per_day, :average_hourly_rate, :currency

  validates_format_of :color, with: /\A#[A-Fa-f0-9]{6}\Z/, allow_blank: true
  validate :color_update_grant, :unless => Proc.new { read_attribute(:color).nil? }

  validates_inclusion_of :currency, :in => CURRENCIES.keys
  validates_numericality_of :work_hours_per_day, greater_than: 0, allow_blank: true
  validates_numericality_of :average_hourly_rate, greater_than: 0, allow_blank: true
  
  embeds_many :authorizations
  has_many :tomatoes
  has_many :projects

  index 'authorizations.uid'
  index 'authorizations.provider'

  has_merit

  def color_update_grant
    errors.add(:color, 'can be customized only after 100 tomatoes tracked') unless granted?('tomatoer', 3)
  end
  
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
    # migrate users' data gracefully
    update_attributes!(omniauth_attributes(auth))

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

  def omniauth_attributes(auth)
    attributes = self.class.omniauth_attributes(auth)

    [:name, :email, :image].each do |attribute|
      attributes.delete(attribute) if send(attribute) && !send(attribute).empty?
    end
    
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
    to_lines(users) do |users_by_day|
      users_by_day ? users_by_day.size : 0
    end
  end

  def self.total_by_day(users)
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

  def currency
    currency_value = read_attribute(:currency)
    currency_value && !currency_value.empty? ? currency_value : User::DEFAULT_CURRENCY
  end

  def currency_unit
    User::CURRENCIES[currency]
  end

  def estimated_revenues
    work_time*Workable::TOMATO_TIME_FACTOR/60/60 * average_hourly_rate.to_f if average_hourly_rate
  end

  def tomatoes_counter(time_period)
    tomatoes_after(Time.zone.now.send("beginning_of_#{time_period}")).count
  end

  def tomatoes_counters
    Hash[[:day, :week, :month].map do |time_period|
      [time_period, tomatoes_counter(time_period)]
    end]
  end

  def any_of_conditions(tags)
    tags.map { |tag| {tags: tag} }
  end

  def tomatoes_by_tags(tags)
    any_of_conditions(tags).empty? ? [] : tomatoes.any_of(any_of_conditions(tags))
  end
end
