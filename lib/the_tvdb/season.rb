module TheTVDB
  class Season < TheTVDB::Record
    
    class << self
      
      def add_series_season (season)
        @series_seasons ||= []
        return false unless season.season_id and season.season_id > 0
        @series_seasons[season.season_id] = season
      end
      
      def [] (index)
        @series_seasons ||= []
        @series_seasons[index]
      end
    end
    
    attr_reader :season_number, :season_id, :series_id, :season_poster, :episodes, :season_posters
    
    def initialize (args = {})
      @season_number = args[:season_number].to_i
      @season_id = args[:season_id].to_i rescue nil
      @series_id = args[:series_id] rescue nil
      @season_posters = args[:season_posters] rescue nil
      @episodes = args[:episodes] rescue nil
      Season.add_series_season self
    end
    
    def season_id= (id)
      @season_id = id.to_i
      Season.add_series_season self
    end
    
    def add_episode (episode)
      @episodes ||= []
      @episodes[episode.episode_number] = episode if episode.is_a? Series_Episode
    end

    def add_poster (poster)
      @season_posters ||= []
      @season_posters << poster
    end
    
    def best_poster
      return nil unless @season_posters.count > 0
      @season_posters.sort {|a,b| (a.rating.to_f * a.rating_count.to_f) <=> (b.rating.to_f * b.rating_count.to_f)}.last
    end

    def [] (episode_num)
      return @episodes[episode_num] if @episodes[episode_num]
      false
    end
    
    def series
      Series[@series_id]
    end
    
  end
end