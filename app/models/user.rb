class User
  include Mongoid::Document
  field :provider, :type => String
  field :uid, :type => String
  field :login, :type => String
  field :name, :type => String
  field :email, :type => String
  attr_accessible :provider, :uid, :login, :name, :email
  
  has_many :tomatoes
  
  def self.create_with_omniauth(auth)
    begin
      create! do |user|
        user.provider = auth['provider']
        user.uid = auth['uid']
        if auth['user_info']
          user.name = auth['user_info']['name'] if auth['user_info']['name'] # Twitter, Google, Yahoo, GitHub
          user.email = auth['user_info']['email'] if auth['user_info']['email'] # Google, Yahoo, GitHub
          user.login = auth['user_info']['nickname'] if auth['user_info']['nickname'] # GitHub
        end
        if auth['extra']['user_hash']
          user.name = auth['extra']['user_hash']['name'] if auth['extra']['user_hash']['name'] # Facebook
          user.email = auth['extra']['user_hash']['email'] if auth['extra']['user_hash']['email'] # Facebook
        end
      end
    rescue Exception
      raise Exception, "cannot create user record"
    end
  end
end
