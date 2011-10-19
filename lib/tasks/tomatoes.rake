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
    File.open(Rails.root.join('config', 'application.rb'), 'rb') do |f|
      # read file content
      file_content = f.read
      
      File.open(f.path, 'w') do |f|
        f.write(file_content.gsub(/VERSION = '(\d+\.\d+\.\d+)'/, "VERSION = '#{version}'"))
      end
    end
    
    puts "Application config file generated"
  end
  
  desc "Generate chrome app manifest"
  task :generate_manifest do
    File.open(Rails.root.join('chrome_app', 'manifest.json'), 'rb') do |f|
      # read file content
      file_content = f.read
      
      manifest = ActiveSupport::JSON.decode(file_content)
      manifest['version'] = version
      
      File.open(f.path, 'w') do |f|
        f.write(manifest.to_json)
      end
    end
    
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
  end
  
  desc "Deploy to Heroku"
  task :deploy => [:new_release, :push] do
    sh "git push heroku master"
    puts "Pushed to heroku/master"
  end
end

def version
  ENV["VERSION"] || next_minor_version
end

def next_minor_version
  TomatoesApp::VERSION.split('.').map do |n|
    2 == TomatoesApp::VERSION.split('.').index(n) ? n.to_i+1 : n
  end.join('.')
end