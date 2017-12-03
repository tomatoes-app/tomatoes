if Rails.env.production?
  GITHUB = {
    'client_id' => ENV['GITHUB_CLIENT_ID'],
    'client_secret' => ENV['GITHUB_CLIENT_SECRET']
  }.freeze
else
  begin
    GITHUB = YAML.load_file(Rails.root.join('config', 'github.yml'))
  rescue Errno::ENOENT
    Rails.logger.warn 'Warning: github.yml configuration is missing'
    # github.yml is not included in the repo
    GITHUB = YAML.load_file(Rails.root.join('config', 'github.example.yml'))
  end
end

if Rails.env.production?
  TWITTER = {
    'consumer_key' => ENV['TWITTER_CONSUMER_KEY'],
    'consumer_secret' => ENV['TWITTER_CONSUMER_SECRET']
  }.freeze
else
  begin
    TWITTER = YAML.load_file(Rails.root.join('config', 'twitter.yml'))
  rescue Errno::ENOENT
    Rails.logger.warn 'Warning: twitter.yml configuration is missing'
    # twitter.yml is not included in the repo
    TWITTER = YAML.load_file(Rails.root.join('config', 'twitter.example.yml'))
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, GITHUB['client_id'], GITHUB['client_secret']
  provider :twitter, TWITTER['consumer_key'], TWITTER['consumer_secret']
end
