Gem::Specification.new do |s|
  s.name        = 'ruby-thetvdb'
  s.version     = '0.0.0'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = "A gem interface to thetvdb.com"
  s.description = "A gem interface to thetvdb.com. Provides easy access to all details of series, seasons and episodes."
  s.author      = "Jon Furrer"
  s.email       = 'jofu@jofu.com'
  s.files       << 'lib/thetvdb.com'
  s.executables << 'thetvdb'
  s.homepage    = 'http://rubygems.org/gems/ruby-thetvdb'
  
  add_runtime_dependency 'json', '>= 1.7.6'
  
end