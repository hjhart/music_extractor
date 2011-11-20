$:.push('lib')
require 'youtube'
require 'uri'

desc "Take a url and download it from youtube."
task :download, :url do |t, args|
  downloader = Youtube.new
  downloader.search_for_url args[:url]
end

desc "Take a file of urls and download it from youtube."
task :download_file, :filename do |t, args|
  downloader = Youtube.new
  File.open(args[:filename], "r").each do |line|
    line = line.chomp.strip
    next if line.empty?
    
    url = URI.extract(line)
    is_url = url.size > 0
    if is_url
      downloader.search_for_url url.first
    else
      search_term = line
      downloader.search_for_string search_term
    end
  end
end

desc "Take a string and search/download it on youtube."
task :search, :search_term do |t, args|
  search_term = args[:search_term].chomp.strip
  downloader = Youtube.new
  downloader.search_for_string search_term
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