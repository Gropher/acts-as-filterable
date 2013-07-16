# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "acts_as_filterable/version"

Gem::Specification.new do |s|
  s.name        = "acts_as_filterable"
  s.version     = ActsAsFilterable::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Gropher"]
  s.email       = ["grophen@gmail.com"]
  s.homepage    = "git@github.com:dultonmedia/acts_as_filterable.git"
  s.summary     = %q{Persistent Ransack search queries}
  s.description = %q{This gem allows you to save your Ransack search queries to database as filter objects. Also you'll be able to choose models, attributes and variable names you want to use in your queries. }

  s.rubyforge_project = "acts_as_filterable"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency('ransack')
  s.add_development_dependency("rspec", ">= 2.0.0")
  s.add_development_dependency("sqlite3", '>= 1.3.5')
  s.add_development_dependency("rails", '>= 3.2.0')
end
