if Rails.env.production?
  GITHUB = {'client_id' => ENV['client_id'], 'client_secret' => ENV['client_secret']}
else
  GITHUB = YAML.load_file("#{Rails.root}/config/github.yml")
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, GITHUB['client_id'], GITHUB['client_secret']
end