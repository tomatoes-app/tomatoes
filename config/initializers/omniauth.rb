if Rails.env.production?
  GITHUB = {'client_id' => ENV['GITHUB_CLIENT_ID'], 'client_secret' => ENV['GITHUB_CLIENT_SECRET']}
else
  begin
    GITHUB = YAML.load_file("#{Rails.root}/config/github.yml")
  rescue
    # github.yml is not included in the repo
    GITHUB = YAML.load_file("#{Rails.root}/config/github.example.yml")
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, GITHUB['client_id'], GITHUB['client_secret']
end