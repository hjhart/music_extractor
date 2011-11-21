require 'music_extractor'

describe MetadataCleaner do
  describe "#extract_song_and_artist" do
    it "should extract the artist and song if it's Artist - Song format" do
      mc = MetadataCleaner.new 
      artist, song = mc.extract_song_and_artist "Bedouin Soundclash - Mountain Top.mp3"
      artist.should == "Bedouin Soundclash"
      song.should == "Mountain Top"
    end
  end
end
