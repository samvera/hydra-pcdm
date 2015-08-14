# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nom/xml/version"

Gem::Specification.new do |s|
  s.name = "nom-xml"
  s.version = Nom::XML::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Chris Beer", "Michael B. Klein"]
  s.email = %q{cabeer@stanford.edu mbklein@gmail.com}
  s.homepage = %q{http://github.com/cbeer/nom-xml}
  s.summary = %q{ A library to help you tame sprawling XML schemas. }
  s.description = %q{ NOM allows you to define a “terminology” to ease translation between XML and ruby objects }

  s.add_dependency 'activesupport', '>= 3.2.18'  # could be rails/AS 3 or 4+, but we don't support old insecure versions
  s.add_dependency 'i18n'
  s.add_dependency 'nokogiri'

  s.add_development_dependency 'equivalent-xml', '~> 0.5.1'
  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency "rake"
  s.add_development_dependency "yard"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.require_paths = ["lib"]
end
