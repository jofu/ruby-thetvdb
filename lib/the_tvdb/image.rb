module TheTVDB
  class Image < TheTVDB::Record

    attr_reader :id, :banner_path, :banner_type, :banner_type2, :colors, :language, :rating, :rating_count, :series_name, :thumbnail_path, :vignette_path, :season, :url
    
    def initialize (args = {})
      @id = args[:id].to_i rescue 0
      @banner_path = args[:banner_path]
      @banner_type = args[:banner_type]
      @banner_type2 = args[:banner_type2] rescue nil
      width, height = @banner_type2.split('x') if @banner_type2 and @banner_type2.to_s.match(/\d+x\d+/)
      @width = width.to_i if width
      @height = height.to_i if height
      @colors = args[:colors].sub(/^\|/,'').sub(/\|$/,'').split('|') rescue nil
      @colors_hex = @colors.collect {|c|
        r,g,b = c.split(',')
        r.to_i.to_s(16) + g.to_i.to_s(16) + b.to_i.to_s(16) if r and g and b
      } if @colors.count > 0 rescue nil
      @language = args[:language] rescue nil
      @rating = args[:rating].to_f rescue Float.new
      @rating_count = args[:rating_count].to_i rescue 0
      @series_name = args[:series_name] rescue nil
      @thumbnail_path = args[:thumbnail_path] rescue nil
      @vignette_path = args[:vignette_path] rescue nil
      @season = args[:season] rescue String.new
      @url = "http://www.thetvdb.com/banners/#{@banner_path}"
      @series_id = args[:series_id] rescue nil
    end

    def series
      Series[@series_id]
    end
    
  end
end