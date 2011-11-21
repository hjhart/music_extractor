require 'yaml'
require 'open-uri'
require 'nokogiri'
require 'uri'
require 'fileutils'

class MetadataCleaner
  attr_accessor :artist, :title, :clean_artist, :clean_title, :attempts
  
  def initialize(artist="", song="")
    @attempts = 0
    @clean_artist = nil
    @clean_title = nil
  end
  
  def construct_url
    base_url = "http://musicbrainz.org/ws/2/"
    resource = "recording?"
    words = @title.split("+")
    query_song = words[0..(-1 * (words.size - @attempts))].join("+")
    parameters = {
      :query => "%22#{query_song}%22+AND+artist%3A%22#{@artist}%22+AND+type%3Aalbum", # exact match
      # :query => "#{query_song}+AND+artist%3A#{@artist}+AND+type%3Aalbum", # not exact match
      :advanced  => 1,
      :type => "recording"
    }
    
    base_url + resource + parameters.map { |key, value| "#{key}=#{value}" }.join("&")
  end
  
  def parse_xml
    sleep 1
    begin
      Nokogiri::HTML(open(construct_url))
    rescue OpenURI::HTTPError
      puts "We're going to fast for MusicBrainz servers! Sleeping 5 seconds."
      sleep 5
      retry
    end
  end
  
  def get_clean_information
    titles, artists = [], []
    total_words = @title.split("+").size
    
    while((titles.size == 0 && artists.size == 0) && @attempts < total_words)      
      @attempts += 1 
      xml = parse_xml
      titles = xml.css("track title")
      artists = xml.css("artist name")     
    end
    
    if titles.size > 0 && artists.size > 0
      @clean_title = titles.first.inner_html
      @clean_artist = artists.first.inner_html
      [@clean_title, @clean_artist]
    else
      false
    end
  end
  
  def save_to_id3 filename
    return false unless @clean_title && @clean_artist
    require 'taglib'

    # Load an ID3v2 tag from a file
    file = TagLib::MPEG::File.new(filename)
    tag = file.id3v2_tag
    tag.artist = @clean_artist
    tag.title = @clean_title
    file.save
  end
  
  def encode string
    string = string.strip.gsub(/[-&]/, " ").gsub(" ", "+")
    URI.encode string
  end
  
  def extract_title_and_artist filename
    # checking for Artist - Song format
    matches = filename.match(/(.*?)-(.*).mp3/)
    if matches
      @artist = encode(matches[1])
      @title = encode(matches[2])
      true
    else
      false
    end
    
  end
  
  def self.tag_files debug=false
    config = YAML.load(File.open('config.yml').read)
    glob_string = "#{config['destination_directory']}/*.mp3"
    Dir.glob(glob_string).each do |file|
      mc = MetadataCleaner.new
      file_without_dir = file.gsub "#{config['destination_directory']}/", ""
      puts "Extracting song information from #{file_without_dir}" if debug
      mc.extract_title_and_artist file_without_dir
      if mc.artist && mc.title
        puts "Found title and artist information in filename" if debug
        puts "Artist: #{mc.artist}" if debug
        puts "Title: #{mc.title}" if debug
        puts "Getting clean information from MusicBrainz..." if debug
        
        unless mc.get_clean_information
          puts "Couldn't find clean information: Trying to swap artist and title around:" if debug
          mc.artist, mc.title = mc.title, mc.artist
          mc.attempts = 0
          mc.get_clean_information
        end
        
        result = mc.save_to_id3 file
        if result
          puts "Saved clean information to the ID3 with the following information" if debug
          puts "Artist: #{mc.clean_artist}" if debug
          puts "Title: #{mc.clean_title}" if debug
        else
          puts "Could not find information on MusicBrainz. Skipping." if debug
        end
      else
        puts "Could not find title and artist information in filename" if debug
      end
      
      if mc.clean_artist && mc.clean_title && config["move_after_matching"]
        FileUtils.mkdir_p(config['matched_directory'])
        music_file = file
        target_music_file = File.join(config['matched_directory'], file_without_dir)
        FileUtils.move(music_file, target_music_file) 
        puts "Moving matched file" if debug
      end
      
      puts "#{file} => Artist: '#{mc.clean_artist}', Title: '#{mc.clean_title}'"
    end
  end
  
end