module TheTVDB
  class Series < TheTVDB::Record
    
    class << self
      def add_series (series)
        @series ||= []
        @series[series.id] = series
      end
      
      def [] (index)
        @series ||= []
        @series[index] = TheTVDB::Record.client.get_series_by_id index unless @series[index]
        return @series[index]
      end
    end
    
    attr_reader :id, :actors, :airs_day_of_week, :airs_time, :content_rating, :first_aired, :genre, :imdb_id, :language, :network, :network_id, :overview, :rating, :rating_count, :runtime, :series_id, :series_name, :status, :added, :added_by, :banner, :fanart, :lastupdated, :poster, :zap2it_id, :seasons, :images
    
    def initialize (args = {})
      @id = args[:id].to_i
      @actors = string_to_array(args[:actors]) rescue nil
      @airs_day_of_week = args[:airs_day_of_week] rescue nil
      @airs_time = args[:airs_time] rescue nil
      @content_rating = args[:content_rating] rescue nil
      @first_aired = args[:first_aired] rescue String.new
      @genres = string_to_array(args[:genre]) rescue nil
      @imdb_id = args[:imdb_id] rescue nil
      @language = args[:language] rescue nil
      @network = args[:network] rescue nil
      @network_id = args[:network_id] rescue nil
      @overview = args[:overview] rescue nil
      @rating = args[:rating].to_f rescue nil
      @rating_count = args[:rating_count].to_i rescue nil
      @runtime = args[:runtime].to_i rescue nil
      @series_id = args[:series_id].to_i rescue nil
      @series_name = args[:series_name] rescue nil
      @status = args[:status] rescue nil
      @added = string_to_date(args[:added]) rescue nil
      @added_by = args[:added_by].to_i rescue nil
      @banner = "http://www.thetvdb.com/banners/#{args[:banner]}" rescue nil
      @fanart = args[:fanart] rescue nil
      @lastupdated = string_to_date(args[:lastupdated]) rescue nil
      @poster = "http://www.thetvdb.com/banners/#{args[:poster]}" rescue nil
      @zap2it_id = args[:zap2it_id] rescue nil
      @url = 'http://thetvdb.com/?tab=series&id=' + @id.to_s
      @seasons = []
      @images = {}
      @client = TheTVDB::Record.client rescue nil
      @client ||= args[:client] rescue nil
    end
    
    def get_images
      response = @client.get_with_key("series/#{@id}/banners.xml")
      raise "HTTP Response Code: " + response.code + " not 200" if response.code.to_i != 200
      doc = REXML::Document.new response.body
      return false unless doc.elements['Banners']
      doc.elements['Banners'].elements.each do |e|
        args = {}
        args[:series_id] = @id
        e.elements.each do |b|
          args[b.name.underscore.intern] = b.text
        end
        @images[args[:banner_type]] ||= []
        image = Image.new(args)
        @images[args[:banner_type]] << image
        if args[:banner_type] == 'season' and args[:banner_type2] == 'season'
          @seasons[args[:season].to_i] ||= Season.new(:season_number => args[:season].to_i, :series_id => @id)
          @seasons[args[:season].to_i].add_poster image
        end
      end
    end
    
    def get_episodes
      response = @client.get_with_key("series/#{@id}/all/" + @client.language + ".xml")
      raise "HTTP Response Code: " + response.code + " not 200" if response.code.to_i != 200
      doc = REXML::Document.new response.body
      return false unless doc.elements['Data'].elements['Episode']
      doc.elements['Data'].elements.each do |e|
        next unless e.name == "Episode"
        args = {}
        e.elements.each do |ee|
          args[ee.name.underscore.intern] = ee.text
        end
        @seasons[args[:season_number].to_i] ||= Season.new(:season_number => args[:season_number].to_i, :series_id => @id, :season_id => args[:seasonid])
        @seasons[args[:season_number].to_i].season_id = args[:seasonid] unless @seasons[args[:season_number].to_i].season_id > 0 rescue nil
        @seasons[args[:season_number].to_i].add_episode Episode.new(args)
      end
    end
    
    def seasons
      @seasons.sort {|a,b| a.season_number <=> b.season_number}
    end
    
    def [] (season_num)
      return @seasons[season_num.to_i] if @seasons[season_num.to_i]
      false
    end
    
    def to_hash
      hash = {}
      instance_variables.each {|var|
        next unless instance_variable_get(var)
        hash[var.to_s.delete("@")] = instance_variable_get(var)
      }
      images = {}
      @images.keys.each do |ik|
        images[ik] ||= []
        @images[ik].each do |i|
          images[ik] << i.to_hash
        end
      end
      hash['images'] = images
      hash['seasons'] = @seasons.collect {|s| s.to_hash}
      hash
    end
    
  end
end 