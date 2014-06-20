source 'http://rubygems.org'

gem 'rails', '3.2.18'

ruby '2.1.2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer'
  gem 'uglifier', '>= 1.0.3'

  # Upload assets to AWS S3
  gem 'asset_sync'
end

gem 'foundation-rails'
gem 'jquery-rails'

# Mongo
gem 'mongoid'
gem 'bson_ext'

# Omniauth
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-twitter'

# Unicorn
gem 'unicorn'

# New Relic
gem 'newrelic_rpm'

# Memcached
gem 'memcachier'
gem 'dalli'

# Pagination
gem 'kaminari'

# Notify exceptions
gem 'exception_notification'

# Static pages
gem 'high_voltage'

group :test do
  gem 'mocha', :require => false
end

group :development do
  gem 'heroku'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'

  # Virtual box provisioning librarian gems
  gem 'librarian'
end
