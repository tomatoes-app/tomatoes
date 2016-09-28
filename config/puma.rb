workers (ENV['WEB_CONCURRENCY'] || 2).to_i
min_threads_count = max_threads_count = (ENV['RAILS_MAX_THREADS'] || 5).to_i
threads min_threads_count, max_threads_count

preload_app!

rackup DefaultRackup
port (ENV['PORT'] || 3000).to_i
environment ENV['RACK_ENV'] || 'development'
