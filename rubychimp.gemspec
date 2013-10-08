# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rubychimp/version"

Gem::Specification.new do |s|
  s.name        = "rubychimp"
  s.version     = Rubychimp::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["hashdog team"]
  s.email       = ["info@hashdog.com"]
  s.homepage    = "http://www.hashdog.com"
  s.summary     = %q{Ruby Wrapper for MailChimp}
  s.description = %q{Ruby Wrapper for MailChimp}

  s.rubyforge_project = "rubychimp"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_development_dependency "rspec", "~> 2.14.1"
  s.add_development_dependency "webmock", "~> 1.13.0"
  s.add_development_dependency "vcr", "~> 2.1.1"
  s.add_dependency "mailchimp", "~> 0.0.9"
end
