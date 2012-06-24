namespace :tomatoes do
  desc "Start new release"
  task :start_release do
    sh "git flow release start '#{version}'"
  end
  
  desc "Finish new release"
  task :finish_release do
    sh "git flow release finish '#{version}'"
  end
  
  desc "Update app version"
  task :update_application do
    file_path = Rails.root.join('config', 'application.rb')
    write_file(file_path, read_file(file_path).gsub(/VERSION = '\d+\.\d+\.\d+'/, "VERSION = '#{version}'"))
    
    puts "Application config file generated"
  end
  
  desc "Generate chrome app manifest"
  task :generate_manifest do
    file_path = Rails.root.join('chrome_app', 'manifest.json')
    file_content = read_file(file_path)
    
    manifest = ActiveSupport::JSON.decode(file_content)
    manifest['version'] = version
    
    write_file(file_path, manifest.to_json)
    
    puts "Chrome app manifest file generated"
  end
  
  desc "Bump version number"
  task :bump_version do
    sh "git commit -am 'bump version number to #{version}'"
  end
  
  desc "New release"
  task :new_release => [:start_release, :update_application, :generate_manifest, :bump_version, :finish_release] do |t, args|
    puts "New release v. #{version} started"
  end
  
  desc "Push repo to origin"
  task :push do
    sh "git push origin develop --tags"
    puts "Pushed to origin/develop"
    
    sh "git push origin master"
    puts "Pushed to origin/master"

    sh "git push heroku master"
    puts "Pushed to heroku/master"
  end
  
  desc "Deploy to Heroku.\nUse this task to deploy a new version of Tomatoes.\nExample 1: 'rake tomatoes:deploy'\nExample 2: 'rake tomatoes:deploy VERSION=0.6'"
  task :deploy => [:new_release, :push] do
    puts "Deployment of version #{version} finished"
  end
end

def version
  ENV["VERSION"] || next_minor_version
end

def next_minor_version
  version_array = TomatoesApp::VERSION.split('.')
  
  if version_array.size > 2
    version_array[2] = version_array[2].to_i+1
  else
    version_array[2] = 1
  end
  
  version_array.join('.')
end

def read_file(filename)
  File.open(filename, 'rb') do |f|
    # read file content
    f.read
  end
end

def write_file(filename, content)
  File.open(filename, 'w') do |f|
    f.write(content)
  end
end