$:.push('lib')
require 'youtube'

desc "Take a url and download it from youtube."
task :download_url, :url do |t, args|
  downloader = Youtube.new args[:url]
  downloader.execute
end

desc "Take a file of urls and download it from youtube."
task :download_file, :filename do |t, args|
  File.open(args[:filename], "r").each do |line|
    url = line.chomp.strip
    downloader = Youtube.new url
    downloader.execute
  end
end

desc "Create a working copy of the config file."
task :init do
  config_templpate = File.join(File.dirname(File.expand_path(__FILE__)), "config.template.yml")
  target_config_file = File.join(File.dirname(File.expand_path(__FILE__)), "config.yml")
  unless File.exists? target_prowl_file
    FileUtils.copy(config_templpate, target_config_file) 
    puts "Creating working config file..."
  end
end