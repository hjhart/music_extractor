# youtube formats take the fmt parameter from this page: http://en.wikipedia.org/wiki/YouTube#Quality_and_codecs

class Youtube
  def initialize
    require 'yaml'
    require 'fileutils'
    @config = YAML.load(File.open('config.yml').read)
  end

  def search_for_string search_term
    search_term.gsub!(/'/, '') 
    exclusion_search_terms = ['live']
    # exclusion_string = exclusion_search_terms.inject("") { |term| 
    options = construct_options {{
      :purpose => "The search term parameter",
      :param => "'ytsearch:#{search_term}'"
    }}
    execute_with options
  end
  
  def search_for_url url
    options = construct_options { {
      :purpose => "The URL parameter",
      :param => "'#{url}'"
    } }
    execute_with options   
  end

  def construct_options
    output_style = "%(title)s.%(ext)s"
    youtube_quality = 18

    options = 
      [{
        :purpose => "Extract audio from video file",
        :param => "--extract-audio"
      }, {
        :purpose => "Set audio format to mp3",
        :param => "--audio-format mp3"
      }, {
        :purpose => "Filename should be nice looking",
        :param => "-o '#{output_style}'"
      }, {
        :purpose => "YouTube quality should be:",
        :param => "-f #{youtube_quality}"
      }]

    options.push({ :purpose => "Retain the video file after finished", :param => "-k"}) if @config['download_movie']
    options.push(yield) if block_given?
    
    options = options.inject("") { |memo, option| memo += "#{option[:param]} " }  
  end
  
  def execute_with flags
    command = "youtube-dl #{flags}"
    puts "Executing: #{command}"
    puts "Downloading and converting the video file now... Please be patient."
    output = `#{command}`
    puts "Done! Output snippet below:"
    puts "---" * 30
    puts output
    puts "---" * 30
    
    puts "Moving audio file..."
    music_filename = output.match(/\[ffmpeg\] Destination: (.*)/)[1]
    music_destination = File.join(@config['destination_directory'], music_filename)
    FileUtils.move(music_filename, music_destination)

    if @config['download_movie']
      puts "Moving video file..."
      movie_filename = output.match(/\[download\] Destination: (.*)/)[1]
      movie_destination = File.join(@config['destination_directory'], movie_filename)
      FileUtils.move(movie_filename, movie_destination) 
    end
    
    puts 
    puts
    
  end
end

