module TheTVDB
  
  VERSION = '0.0.1'
  
  autoload :Retryable, 'the_tvdb/retryable'
  autoload :Client,    'the_tvdb/client'
  autoload :Record,    'the_tvdb/record'
  autoload :Series,    'the_tvdb/series'
  autoload :Image,     'the_tvdb/image'
  autoload :Season,    'the_tvdb/season'
  autoload :Episode,   'the_tvdb/episode'
  
end

class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
  def is_number?
    true if Float(self) rescue false
  end
end