module TheTVDB
  class Client
    require "net/http"
    require "uri"
    require 'rexml/document'
    
    class << self
      attr_reader :current
      # @!attribute [r] current
      #   @return [TheTVDB::Client] Holds the current connection for use outside of the instance
      
      def current= (client)
        @current = client
      end
    end
    
    attr_reader :api_key
    attr_accessor :language, :base_uri
    # @!attribute [r] api_key
    #   @return [String] The tvdb api key used in queries
    # @!attribute [rw] language
    #   @return [String] The two-letter abbreviation of the language to request in queries
    # @!attribute [rw] base_uri
    #   @return [String] The base URI to use in queries
    
    # Creates a TheTVDB::Client instance, used as the basis for all requests
    #
    # @param [String] api_key Your tvdb api key as a string
    # @param [Hash] options A hash of options with keys as symbols
    # @option options [String] :language ('en') The language of data requested represented as a two-letter abbreviation
    # @option options [String] :base_uri ('http://www.thetvdb.com/api') The base URI to use when making requests
    # @return [TheTVDB::Client]
    #
    # @example Create a new TheTVDB::Client with French as the language
    #   TheTVDB::Client.new(API_KEY,:language => 'fr') #=> TheTVDB::Client
    def initialize (api_key, options={})
      @api_key = api_key
      @language = options[:language] rescue nil
      @language ||= 'en'
      @base_uri = options[:base_uri] rescue nil
      @base_uri ||= 'http://www.thetvdb.com/api'
      check_api_key!
      TheTVDB::Client.current = self
    end
    
    # Convenience method to get a TheTVDB::Series instance by the series_id
    #
    # @param [Integer] series_id The series ID from tvdb to fetch
    # @return [TheTVDB::Series]
    # @see TheTVDB::Client.get_series_by_id
    #
    # @example Get all the data for Dexter where tvdb is a TheTVDB::Client instance
    #   tvdb[79349] #=> TheTVDB::Series for Dexter
    def [] (series_id)
      Series[series_id]
    end
    
    # Get mirrors currently useable with tvdb
    # @api private
    # @deprecated tvdb no longer expects users to control load by selecting mirrors, used internally as part of api key validating
    # @return [Boolean]
    def mirrors
      response = self.get_with_key('mirrors.xml')
      raise "HTTP Response Code: " + response.code + " not 200" if response.code.to_i != 200
      return true
    end
    
    # Find series by name
    #
    # @param [String] series_name The name of a series to search for
    # @return [TheTVDB::Series] If a single series matches the String provided
    # @return [Array<TheTVDB::Series>] If multiple series match the String provided
    def get_series (series_name)
    end
    
    # Find series by IMDB or ZAP2it ID
    #
    # @param [String] remote_source The name of the remote source, 'IMDB' or 'ZAP2it'
    # @param [String] remote_id The ID of the series on the remote source
    # @return [TheTVDB::Series]
    def get_series_by_remote_id (remote_source, remote_id)
    end
    
    # Get a TheTVDB::Episode instance by the series_id and the air_date
    #
    # @param [String] series_id The series ID from tvdb
    # @param [Time] air_date A Time representing the date the episode aired
    # @return [TheTVDB::Episode]
    def get_episode_by_air_date (series_id, air_date)
    end
    
    # Get a TheTVDB::Series instance by the series_id
    #
    # @param [Integer] series_id The series ID from tvdb to fetch
    # @return [TheTVDB::Series]
    # @see TheTVDB::Client.get_series_by_id
    #
    # @example Get all the data for Dexter where tvdb is a TheTVDB::Client instance
    #   tvdb.get_series_by_id(79349) #=> TheTVDB::Series for Dexter
    def get_series_by_id (id)
      response = get_with_key("series/#{id}/#{@language}.xml")
      raise "HTTP Response Code: " + response.code + " not 200" if response.code.to_i != 200
      doc = REXML::Document.new response.body
      return false unless doc.elements['Data'].elements['Series']
      args = {}
      doc.elements['Data'].elements['Series'].elements.each do |e|
          args[e.name.underscore.intern] = e.text
      end
      args[:client] = self
      series = Series.new(args)
      series.get_images
      series.get_episodes
      series
    end
    
    # @api private
    # An internal method used to make calls on the tvdb api
    def get_with_key (path)
      uri = URI.parse(self.base_uri + '/' + self.api_key + '/' + path)
      response = false
      begin
        TheTVDB::Retryable.retry do
          http = Net::HTTP.new(uri.host, uri.port)
          response = http.request(Net::HTTP::Get.new(uri.request_uri))
        end
      rescue Tvdbr::RetryableError => e
        return nil
      end
      return response
    end
    
    # @api private
    # And internal method used to validate the supplied api key
    def check_api_key!
      begin
        self.mirrors
      rescue
        raise "The api_key provided '#{self.api_key}' does not appear to be valid"
      end
    end
    
  end
end