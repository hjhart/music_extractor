$:.push('lib')
require 'youtube'

desc "Take a url and download it from youtube."
task :download_url, :url do |t, args|
  downloader = Youtube.new
  downloader.search_for_url args[:url]
end

desc "Take a file of urls and download it from youtube."
task :download_file, :filename do |t, args|
  downloader = Youtube.new
  File.open(args[:filename], "r").each do |line|
    url = line.chomp.strip
    downloader.search_for_url url
  end
end

desc "Take a string and search/download it on youtube."
task :search, :search_term do |t, args|
  search_term = args[:search_term].chomp.split
  downloader = Youtube.new
  downloader.search_for_string search_term
end

desc "Take a file of search terms and download it from youtube."
task :search_file, :filename do |t, args|
  downloader = Youtube.new
  File.open(args[:filename], "r").each do |line|
    search_term = line.chomp.strip
    downloader.search_for_string search_term
  end
end

desc "Create a working copy of the config file."
task :init do
  config_templpate = File.join(File.dirname(File.expand_path(__FILE__)), "config.template.yml")
  target_config_file = File.join(File.dirname(File.expand_path(__FILE__)), "config.yml")
  unless File.exists? target_config_file
    FileUtils.copy(config_templpate, target_config_file) 
    puts "Creating working config file..."
  end
end