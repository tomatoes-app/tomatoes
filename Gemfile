source 'http://rubygems.org'
ruby '2.3.3'

gem 'rails', '4.2.7.1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '>= 3.2'
  gem 'therubyracer'
  gem 'uglifier', '>= 1.0.3'

  # Upload assets to AWS S3
  gem 'asset_sync'
  gem 'fog-aws'
end

gem 'jquery-rails'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'bootstrap-social-rails'

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
gem 'kaminari', '~> 1.0'
gem 'kaminari-mongoid', '~> 1.0'

# Notify exceptions
gem 'exception_notification'

# Static pages
gem 'high_voltage'
gem 'rdiscount'

# Async tasks
gem 'sucker_punch', '~> 2.0'

gem 'octokit'
gem 'twitter'

group :production do
  gem 'rails_12factor'
end

group :test do
  gem 'mocha', require: false
  gem 'minitest-reporters'
  gem 'simplecov', require: false
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'pry'
  gem 'test-unit', '~> 3.0'
  gem 'byebug'
  gem 'rubocop', '~> 0.43.0', require: false
end
