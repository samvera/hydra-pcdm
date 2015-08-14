# -*- encoding: utf-8 -*-
# stub: rdf-isomorphic 1.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rdf-isomorphic"
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ben Lavender", "Arto Bendiken"]
  s.date = "2013-11-14"
  s.description = "RDF.rb plugin for graph bijections and isomorphic equivalence."
  s.email = "public-rdf-ruby@w3.org"
  s.homepage = "http://ruby-rdf.github.com/rdf-isomorphic"
  s.licenses = ["Public Domain"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubyforge_project = "rdf"
  s.rubygems_version = "2.4.5"
  s.summary = "RDF.rb plugin for graph bijections and isomorphic equivalence."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rdf>, [">= 1.1"])
      s.add_development_dependency(%q<rdf-spec>, [">= 1.1"])
      s.add_development_dependency(%q<rspec>, [">= 2.14.0"])
      s.add_development_dependency(%q<yard>, [">= 0.8.7"])
    else
      s.add_dependency(%q<rdf>, [">= 1.1"])
      s.add_dependency(%q<rdf-spec>, [">= 1.1"])
      s.add_dependency(%q<rspec>, [">= 2.14.0"])
      s.add_dependency(%q<yard>, [">= 0.8.7"])
    end
  else
    s.add_dependency(%q<rdf>, [">= 1.1"])
    s.add_dependency(%q<rdf-spec>, [">= 1.1"])
    s.add_dependency(%q<rspec>, [">= 2.14.0"])
    s.add_dependency(%q<yard>, [">= 0.8.7"])
  end
end
