source 'https://rubygems.org'
ruby '2.4.10'

gem 'rails', '~> 5.1'

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

gem 'bootstrap-sass', '~> 3.3.6'
gem 'bootstrap-social-rails'
gem 'bootstrap_form'
gem 'jquery-rails'

gem 'http_accept_language'

# Mongo
gem 'mongoid'

# Omniauth
gem 'omniauth'
gem 'omniauth-twitter'
# Fix authentication using query params deprecation
# See https://github.com/omniauth/omniauth-github/pull/84
gem 'omniauth-github', '>= 1.4'

# Puma
gem 'puma'

# New Relic
gem 'newrelic_rpm'

# Memcached
gem 'dalli'
gem 'memcachier'

# Pagination
gem 'kaminari', '~> 1.0'
gem 'kaminari-mongoid', '~> 1.0'

# Notify exceptions
gem 'exception_notification'

# Static pages
gem 'high_voltage'
gem 'rdiscount', '~> 2.2.0.2'

# Async tasks
gem 'sucker_punch', '~> 2.0'

gem 'octokit'
gem 'twitter'

group :production do
  gem 'rails_12factor'
end

group :test do
  gem 'coveralls', require: false
  gem 'minitest-reporters'
  gem 'mocha', require: false
  gem 'simplecov', require: false
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'byebug'
  gem 'pry'
  gem 'rubocop', '~> 0.51.0', require: false
  gem 'test-unit', '~> 3.0'
end

# Security upgrades
gem 'actionview', '>= 5.1.6.2'
gem "nokogiri", ">= 1.10.4"
