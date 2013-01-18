module TheTVDB
  class Episode < TheTVDB::Record
    
    class << self
      
      def add_series_episode (episode)
        @series_episodes ||= []
        @series_episodes[episode.id] = episode
      end
      
      def [] (index)
        @series_episodes ||= []
        @series_episodes[index]
      end
    end
    
    attr_reader :id, :seasonid, :episode_number, :episode_name, :first_aired, :guest_stars, :director, :writer, :overview, :production_code, :lastupdated, :flagged, :dvd_discid, :dvd_season, :dvd_episodenumber, :dvd_chapter, :absolute_number, :filename, :seriesid, :mirrorupdate, :imdb_id, :ep_img_flag, :rating, :season_number, :language
    alias_method :screen_shot, :filename
    alias_method :screenshot, :filename
    alias_method :season_id, :seasonid
    alias_method :series_id, :seriesid
    
    
    def initialize (args = {})
      @id = args[:id].to_i
      @combined_episodenumber = args[:combined_episodenumber].to_f rescue nil
      @combined_season = args[:combined_season].to_f rescue nil
      @dvd_chapter = args[:dvd_chapter].to_f rescue nil
      @dvd_discid = args[:dvd_discid].to_f rescue nil
      @dvd_episodenumber = args[:dvd_episodenumber].to_f rescue nil
      @dvd_season = args[:dvd_season].to_f rescue nil
      @director = args[:director] rescue nil
      @ep_img_flag = args[:ep_img_flag] rescue nil
      @episode_name = args[:episode_name] rescue nil
      @episode_number = args[:episode_number].to_i
      @first_aired = args[:first_aired] rescue nil
      @guest_stars = args[:guest_stars] rescue nil
      @imdb_id = args[:imdb_id] rescue nil
      @language = args[:language] rescue 'en'
      @overview = args[:overview] rescue nil
      @production_code = args[:production_code] rescue nil
      @rating = args[:rating].to_f rescue nil
      @rating_count = args[:rating_count].to_i rescue nil
      @season_number = args[:season_number].to_i rescue nil
      @writer = args[:writer] rescue nil
      @absolute_number = args[:absolute_number].to_i rescue nil
      @airsafter_season = args[:airsafter_season].to_i rescue nil
      @airsbefore_episode = args[:airsbefore_episode].to_i rescue nil
      @airsbefore_season = args[:airsbefore_season].to_i rescue nil
      @filename = "http://www.thetvdb.com/banners/#{args[:filename]}" rescue String.new
      @lastupdated = Time.at(args[:lastupdated]).gmtime rescue Time.new.gmtime
      @seasonid = args[:seasonid].to_i rescue 0
      @seriesid = args[:seriesid].to_i rescue 0
      Episode.add_series_episode self
    end

    def series
      Series[@seriesid]
    end
    
    def season_poster
      Season[@seasonid].best_poster
    end
    
    def series_actors
      Series[@seriesid].actors
    end
    
    def to_hash
      hash = {}
      instance_variables.each {|var|
        next unless instance_variable_get(var)
        hash[var.to_s.delete("@")] = instance_variable_get(var)
      }
      hash.delete 'filename'
      hash['screenshot'] = @filename
      hash['season_poster'] = season_poster.url
      hash['series_actors'] = series_actors
      hash
    end
    
  end
end