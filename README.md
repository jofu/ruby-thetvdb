# ruby-thetvdb

A simple gem for accessing the [www.thetvdb.com API](http://thetvdb.com/wiki/index.php?title=Programmers_API). Created by Jon Furrer.

While there are a few TVDB gems out there, there were some features I wanted that I didn't find in others. Among these are:

  * Ability to get information for series episodes using the series id, season number and episode number
  * Easy access to all info from a series, season or episode

## Installation

    $ sudo gem install ruby-thetvdb

### Usage

Create a client connection

	require 'the_tvdb'
	
	## Create a client
	tvdb = TheTVDB::Client.new(API_KEY)
	
	## Get a series by ID
	dexter = tvdb.get_series_by_id(79349)
	### or
	dexter = tvdb[79349]
	
	## Get a season of a series
	dexter_season_3 = dexter.seasons[3]
	### or
	dexter_season_3 = dexter[3]
	### or
	dexter_season_3 = tvdb[79349][3]
	
	## Get the highest rated poster for a season
	dexter_season_3.best_poster
	
	## Get an episode of a season of a series
	dexter_season_3_episode_5 = dexter_season_3.episodes[5]
	### or
	dexter_season_3_episode_5 = dexter[3][5]
	### or
	dexter_season_3_episode_5 = tvdb[79349][3][5]