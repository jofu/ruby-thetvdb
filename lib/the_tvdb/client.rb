module TheTVDB
  class Client
    require "net/http"
    require "uri"
    require 'rexml/document'
    
    base_uri = 'http://www.thetvdb.com/api'
    
    :attr_reader :api_key
    
    # Creates a TheTVDB::Client instance, used as the basis for all requests
    # TheTVDB::Client.new('your api key', options) returns a TheTVDB::Client
    def initialize (api_key, options={})
      @api_key = api_key
      @options = options
      @options['language'] ||= 'en'
      check_api_key!
      TheTVDB::Record.client = self
    end
    
    # Sets the language to use when making calls to The TVDB
    # client_instance.language = 'language 2 letter code, i.e. en'
    def language= (language)
      @options['language'] = language
    end
    
    # Convenience method to get a TheTVDB::Series instance by the series_id
    # TheTVDB::Client_instance\[1234\] return a TheTVDB::Series instance for the series ID 1234
    def [] (series_id)
      Series[series_id]
    end
    
    def mirrors
      response = get_with_key('mirrors.xml')
      raise "HTTP Response Code: " + response.code + " not 200" if response.code != 200
      doc = REXML::Document.new response.body
    end
    
    def get_series (series_name)
    end
    
    def get_series_by_id (id)
      response = get_with_key('series/#{id}/#{@language}.xml')
      raise "HTTP Response Code: " + response.code + " not 200" if response.code != 200
      doc = REXML::Document.new response.body
      return false unless doc.elements['Data'].elements['Series']
      args = {}
      doc.elements['Data'].elements['Series'].elements.each do |e|
          args[e.name.underscore.intern] = e.text
      end
      series = Series.new(args)
      series.get_images
      series.get_episodes
      series
    end
    
    protected
    
    def get_with_key (path)
      uri = URI.parse(BASE_URI + '/' + @api_key + '/' + path)
      http = Net::HTTP.new(uri.host, uri.port)
      response = false
      begin
        Tvdbr::Retryable.retry(:on => MultiXml::ParseError) do
          response = http.request(Net::HTTP::Get.new(uri.request_uri))
        end
      rescue Tvdbr::RetryableError => e
        return nil
      end
      return response
    end
    
    def check_api_key!
      begin
        self.mirrors
      rescue
        raise "The api_key provided '#{self.api_key}' does not appear to be valid"
      end
    end
    
  end
end