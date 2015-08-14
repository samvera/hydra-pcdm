# -*- encoding: utf-8 -*-
# stub: rdf-trix 1.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rdf-trix"
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Arto Bendiken"]
  s.date = "2013-12-06"
  s.description = "RDF.rb plugin for parsing/serializing TriX data."
  s.email = "public-rdf-ruby@w3.org"
  s.homepage = "http://ruby-rdf.github.com/rdf-trix"
  s.licenses = ["Public Domain"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubyforge_project = "rdf"
  s.rubygems_version = "2.4.5"
  s.summary = "TriX support for RDF.rb."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rdf>, [">= 1.1"])
      s.add_development_dependency(%q<rdf-spec>, [">= 1.1"])
      s.add_development_dependency(%q<rspec>, [">= 2.14"])
      s.add_development_dependency(%q<yard>, [">= 0.8.5"])
      s.add_development_dependency(%q<nokogiri>, [">= 1.5.9"])
    else
      s.add_dependency(%q<rdf>, [">= 1.1"])
      s.add_dependency(%q<rdf-spec>, [">= 1.1"])
      s.add_dependency(%q<rspec>, [">= 2.14"])
      s.add_dependency(%q<yard>, [">= 0.8.5"])
      s.add_dependency(%q<nokogiri>, [">= 1.5.9"])
    end
  else
    s.add_dependency(%q<rdf>, [">= 1.1"])
    s.add_dependency(%q<rdf-spec>, [">= 1.1"])
    s.add_dependency(%q<rspec>, [">= 2.14"])
    s.add_dependency(%q<yard>, [">= 0.8.5"])
    s.add_dependency(%q<nokogiri>, [">= 1.5.9"])
  end
end
