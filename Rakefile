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
    url = line.chomp
    downloader = Youtube.new url
    downloader.execute
  end
end