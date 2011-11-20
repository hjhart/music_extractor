# youtube formats take the fmt parameter from this page: http://en.wikipedia.org/wiki/YouTube#Quality_and_codecs

class Youtube
  def initialize(url = "http://www.youtube.com/watch?v=feIiA__MiMM")
    require 'yaml'
    require 'fileutils'
    
    @video_link = url
    @config = YAML.load(File.open('config.yml').read)
  end

  def construction_options
    output_style = "%(title)s.%(ext)s"
    youtube_quality = 18

    options = 
      [{
        :purpose => "The URL parameter",
        :param => "'#{@video_link}'"
      }, {
        :purpose => "Extract audio from video file",
        :param => "--extract-audio"
      }, {
        :purpose => "Set audio format to mp3",
        :param => "--audio-format mp3"
      }, {
        :purpose => "Retain the video file after finished",
        :param => "-k"
      }, {
        :purpose => "Filename should be nice looking",
        :param => "-o '#{output_style}'"
      }, {
        :purpose => "YouTube quality should be:",
        :param => "-f #{youtube_quality}"
      }]

    options.push({ :purpose => "Retain the video file after finished", :param => "-k"}) if @config['download_movie']
    options = options.inject("") { |memo, option| memo += "#{option[:param]} " }  
  end
  
  def execute
    options = construction_options
    command = "youtube-dl #{options}"
    puts "Executing: #{command}"
    output = `#{command}`
    
    puts "We captured this:"
    puts output
    
    mp3_filename = output.match(/\[ffmpeg\] Destination: (.*)/)[1]
    mp4_filename = output.match(/\[download\] Destination: (.*)/)[1]
    mp3_destination = File.join(@config['destination_directory'], mp3_filename)
    mp4_destination = File.join(@config['destination_directory'], mp4_filename)
    
    FileUtils.move(mp3_filename, mp3_destination)
    FileUtils.move(mp4_filename, mp4_destination) if @config['download_movie']
    
    
  end
end

