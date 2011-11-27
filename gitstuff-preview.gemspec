# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gitstuff-preview/version"

Gem::Specification.new do |s|
  s.name        = "gitstuff-preview"
  s.version     = Gitstuff::Preview::VERSION
  s.authors     = ["Jesse Kriss"]
  s.email       = ["jesse@jklabs.net"]
  s.homepage    = "http://github.com/jkriss/gitstuff-preview"
  s.summary     = %q{Handy gem for previewing Gitstuff sites}
  s.description = %q{gitstuff-preview runs a local web server to preview Gitstuff templates}

  s.rubyforge_project = "gitstuff-preview"

  s.files         = `git ls-files`.split("\n")
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  # s.files         = `ls`.split("\n")
  s.executables   = ["gitstuff-preview"]
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "sinatra"
  s.add_runtime_dependency "liquid"
  s.add_runtime_dependency "rdiscount"
  s.add_runtime_dependency "hashie"
  s.add_runtime_dependency "thin"
  s.add_runtime_dependency "jekyll"
end
