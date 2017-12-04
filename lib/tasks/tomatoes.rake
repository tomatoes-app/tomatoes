namespace :tomatoes do
  # Start new release
  task :start_release do
    sh "git flow release start '#{version}'"
  end

  # Finish new release
  task :finish_release do
    sh "git flow release finish '#{version}'"
  end

  # Update app version
  task :update_application do
    file_path = Rails.root.join('config', 'application.rb')
    write_file(file_path, read_file(file_path).gsub(/VERSION = '\d+\.\d+\.\d+'/, "VERSION = '#{version}'"))

    puts 'Application config file generated'
  end

  # Generate chrome app manifest
  task :generate_manifest do
    file_path = Rails.root.join('chrome_app', 'manifest.json')
    file_content = read_file(file_path)

    manifest = ActiveSupport::JSON.decode(file_content)
    manifest['version'] = version

    write_file(file_path, manifest.to_json)

    puts 'Chrome app manifest file generated'
  end

  # Bump version number
  task :bump_version do
    sh "git commit -am 'bump version number to #{version}'"
  end

  # New release
  task new_release: %i[start_release update_application generate_manifest bump_version finish_release] do |_t, _args|
    puts "New release v. #{version} started"
  end

  # Push repo to origin and heroku remotes
  task :push do
    sh 'git push origin develop --tags'
    puts 'Pushed to origin/develop'

    sh 'git push origin master'
    puts 'Pushed to origin/master'

    sh 'git push heroku master'
    puts 'Pushed to heroku/master'
  end

  desc "Deploy to Heroku.\n" \
    "Use this task to tag a new version of the app and to deploy it.\n" \
    "Example 1: 'rake tomatoes:deploy'\n" \
    "Example 2: 'rake tomatoes:deploy VERSION=0.6'"
  task deploy: %i[test new_release push] do
    puts "Deployment of version #{version} finished"
  end

  namespace :db do
    desc 'Make a copy of production db and load it to local mongodb'
    task :dump do
      mongodb_url = `heroku config | grep MONGO | awk '{print $2;}'`
      mongodb_url = URI.parse(mongodb_url)
      system "mongodump -h #{mongodb_url.host}:#{mongodb_url.port} " \
        "-d #{mongodb_url.path.tr('/', '')} " \
        "-u #{mongodb_url.user} " \
        "-p #{mongodb_url.password} " \
        '-o db/backups/'
      system "mongorestore -h localhost --drop -d tomatoes_app_development db/backups/#{mongodb_url.path.tr('/', '')}/"
    end
  end
end

def version
  ENV['VERSION'] || next_minor_version
end

def next_minor_version
  version_array = TomatoesApp::VERSION.split('.')

  version_array[2] = if version_array.size > 2
                       version_array[2].to_i + 1
                     else
                       1
                     end

  version_array.join('.')
end

def read_file(filename)
  File.open(filename, 'rb', &:read)
end

def write_file(filename, content)
  File.open(filename, 'w') do |f|
    f.write(content)
  end
end
