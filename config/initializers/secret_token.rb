# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
TomatoesApp::Application.config.secret_token = ENV['SESSION_STORE_SECRET_TOKEN'] || 'df4a92e8e3f5306c421693fc5d7a8bea'
