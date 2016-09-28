source 'http://rubygems.org'
ruby '2.0.0'

gem 'rails', '3.2.22.4'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  # gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer'
  gem 'uglifier', '>= 1.0.3'

  # Upload assets to AWS S3
  gem 'asset_sync', '~> 0.4.3'
end

gem 'jquery-rails'

# Mongo
gem 'mongoid', '~> 3.1.7'
gem 'bson_ext'

# Omniauth
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-twitter'

# Unicorn
gem 'unicorn', '~> 4.9.0'

# New Relic
gem 'newrelic_rpm', '~> 3.5.8'

# Memcached
gem 'memcachier'
gem 'dalli'

# Pagination
gem 'kaminari', '~> 0.13.0'

# Notify exceptions
gem 'exception_notification'

# Static pages
gem 'high_voltage'

group :production do
  gem 'rails_12factor'
end

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

group :development, :test do
  gem 'dotenv-rails'
  gem 'pry'
end
