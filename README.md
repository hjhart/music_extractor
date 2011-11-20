## Summary

music_extractor is a non-elegant prototype I whipped up because of the lack of decent youtube-to-mp3 solutions on the internet. It is dependant on two different libraries, but it makes the process of downloading and converting [any youtube-dl compatible online video](http://rg3.github.com/youtube-dl/documentation.html#d4) painless. 

Sites include (but are not limited to): **Youtube, Vimeo, Google Video, MetaCafe, Yahoo Video.**

## Prerequisites:

I apologize for there being so many. This is more of a proof of concept than a slick implementation. However, if youre on a UNIX-based system this really shouldn't be that hard to set up.

* Python (comes with OSX)
* Ruby (comes with OSX)
* Have ffmpeg installed (usually a brew install ffmpeg does the trick)
* Have youtube-dl installed [instructions](http://rg3.github.com/youtube-dl/)

## Setup

Copy over config file. This rake task will create a config.yml. Use the configuration section below to configure Youtube
	
	rake init

## Usage:

Download a single URL

	rake download["http://www.youtube.com/watch?v=xNQ5fj9uqVo"]
	
Download multiple urls (one url per line in a text file)

	rake download_file["urls.txt"]
	
Download using a search term (only on youtube)

	rake search["Michael Jackson - Thriller"]
	
Download multiple search terms (one search term per line in a text file)

	rake search_file["search_terms.txt"]

## Configuration

`destination_directory` is fairly obvious. Right now only absolute or relative links work (nothing using the home dir shortcut: ~)

`download_movie` by default the movie file will be deleted. If you want to retain the movie and the music file, set this to true.

`music_format` - by default this is set to mp3. You have the choice of: "aac", "vorbis" or "mp3"

## TODO:

* Configurable video types/qualities
* download a file based on a search term best result
* Figure out a "best result" algorithm for youtube
* mkdir_p the destination directory?
* Edit meta data (upon importing into iTunes we should get an artist and a title at least - perhaps a year and genre - query allmusic from mashable?)
* download N number of search_term videos (e.g. rake search_multiple["Cold War Kids", 15] would download 15 songs from Cold War Kids)