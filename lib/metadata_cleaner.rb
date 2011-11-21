require 'open-uri'
require 'nokogiri'
require 'uri'

class MetadataCleaner
  def initialize artist, song
    @artist = encode(artist)
    @song = encode(song)
    @clean_artist = nil
    @clean_song = nil
  end
  
  def construct_url
    base_url = "http://musicbrainz.org/ws/2/"
    resource = "recording?"
    parameters = {
      :query => "%22#{@song}%22+AND+artist%3A%22#{@artist}%22+AND+type%3Aalbum",
      :advanced  => 1,
      :type => "recording"
    }
    
    base_url + resource + parameters.map { |key, value| "#{key}=#{value}" }.join("&")
  end
  
  def parse_xml
    Nokogiri::HTML(open(construct_url))
  end
  
  def get_clean_information
    xml = parse_xml
    @clean_song = xml.css("track title").first.inner_html
    @clean_artist = xml.at_css("artist name").inner_html
    [@clean_song, @clean_artist]
  end
  
  
  
  def encode string
    string = string.gsub(" ", "+")
    URI.encode string
  end
  
end