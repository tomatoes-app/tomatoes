namespace :tomatoes do
  desc "Generate chrome app manifest"
  task :generate_manifest do
    File.open(Rails.root.join('chrome_app', 'manifest.json'), 'rb') do |f|
      file_content = f.read
      
      manifest = ActiveSupport::JSON.decode(file_content)
      manifest['version'] = TomatoesApp::VERSION
      
      File.open(f.path, 'w') do |f|
        f.write(manifest.to_json)
      end
    end
    
    puts "Manifest file generated"
  end
end