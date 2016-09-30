workers ENV['WEB_CONCURRENCY'] || 2
min_threads_count = max_threads_count = ENV['RAILS_MAX_THREADS'] || 5
threads min_threads_count, max_threads_count

preload_app!

rackup DefaultRackup
port ENV['PORT'] || 3000
environment ENV['RACK_ENV'] || 'development'
