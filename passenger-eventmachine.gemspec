# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "passenger-eventmachine/version"

Gem::Specification.new do |s|
  s.name        = "passenger-eventmachine"
  s.version     = PhusionPassenger::EventMachine::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Simon Menke"]
  s.email       = ["simon.menke@gmail.com"]
  s.homepage    = "http://github.com/fd"
  s.summary     = %q{Use Phusion Passenger and EventMachine}
  s.description = %q{A small layer between Phusion Passenger and EventMachine.}

  s.rubyforge_project = "passenger-eventmachine"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency 'eventmachine', '>= 0.12.10'
end
