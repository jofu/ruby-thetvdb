# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "the_tvdb"

Gem::Specification.new do |s|
  s.name        = 'ruby-thetvdb'
  s.version     = TheTVDB::VERSION
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = "A gem interface to thetvdb.com"
  s.description = "A gem interface to thetvdb.com. Provides easy access to all details of series, seasons and episodes."
  s.author      = "Jon Furrer"
  s.email       = 'jofu@jofu.com'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.homepage    = 'https://github.com/jofu/ruby-thetvdb'
  s.add_development_dependency "rake"
end