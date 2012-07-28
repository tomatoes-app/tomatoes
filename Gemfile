source 'http://rubygems.org'

gem 'rails', '3.2.7'

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

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

gem 'jquery-rails'

# Mongo
gem 'mongoid'
gem 'bson_ext'

# Omniauth
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-twitter'

# Thin
gem 'thin'

# Unicorn
gem 'unicorn'

# New Relic
gem 'newrelic_rpm'

# Memcached
gem 'dalli'

# Pagination
gem 'kaminari'

# Gamification
gem 'merit'

group :development, :test do
  gem 'heroku'
  gem 'mocha'

  # Virtual box provisioning with vagrant and librarian gems
  gem 'vagrant'
  gem 'librarian'
end