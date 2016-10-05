source 'http://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.2.7.1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'therubyracer'
  gem 'uglifier', '>= 1.0.3'

  # Upload assets to AWS S3
  gem 'asset_sync'
  gem 'fog', '~>1.20', require: 'fog/aws/storage'
end

gem 'jquery-rails'

# Mongo
gem 'mongoid'

# Omniauth
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-twitter'

# Puma
gem 'puma', '~> 3.6.0'

# New Relic
gem 'newrelic_rpm'

# Memcached
gem 'memcachier'
gem 'dalli'

# Pagination
gem 'kaminari'
gem 'kaminari-mongoid'

# Notify exceptions
gem 'exception_notification'

# Static pages
gem 'high_voltage'

# Asyn tasks
gem 'sucker_punch', '~> 2.0'

group :production do
  gem 'rails_12factor'
end

group :test do
  gem 'mocha', require: false
  gem 'minitest-reporters'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rubocop', '~> 0.43.0', require: false
end

group :development, :test do
  gem 'pry'
end
