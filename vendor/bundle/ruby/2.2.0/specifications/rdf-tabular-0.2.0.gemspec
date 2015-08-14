# -*- encoding: utf-8 -*-
# stub: rdf-tabular 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rdf-tabular"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Gregg Kellogg"]
  s.date = "2015-07-16"
  s.description = "RDF::Tabular processes tabular data with metadata creating RDF or JSON output."
  s.email = "public-rdf-ruby@w3.org"
  s.homepage = "http://github.com/ruby-rdf/rdf-tabular"
  s.licenses = ["Public Domain"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.4.5"
  s.summary = "Tabular Data RDF Reader and JSON serializer."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bcp47>, [">= 0.3.3", "~> 0.3"])
      s.add_runtime_dependency(%q<rdf>, [">= 1.1.7", "~> 1.1"])
      s.add_runtime_dependency(%q<rdf-xsd>, ["~> 1.1"])
      s.add_runtime_dependency(%q<json-ld>, ["~> 1.1"])
      s.add_runtime_dependency(%q<addressable>, ["~> 2.3"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
      s.add_development_dependency(%q<rdf-spec>, ["~> 1.1"])
      s.add_development_dependency(%q<rdf-turtle>, ["~> 1.1"])
      s.add_development_dependency(%q<rdf-isomorphic>, ["~> 1.1"])
      s.add_development_dependency(%q<sparql>, ["~> 1.1"])
      s.add_development_dependency(%q<rspec>, ["= 3.2.0", "~> 3.0"])
      s.add_development_dependency(%q<rspec-its>, ["~> 1.0"])
      s.add_development_dependency(%q<webmock>, ["~> 1.17"])
    else
      s.add_dependency(%q<bcp47>, [">= 0.3.3", "~> 0.3"])
      s.add_dependency(%q<rdf>, [">= 1.1.7", "~> 1.1"])
      s.add_dependency(%q<rdf-xsd>, ["~> 1.1"])
      s.add_dependency(%q<json-ld>, ["~> 1.1"])
      s.add_dependency(%q<addressable>, ["~> 2.3"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
      s.add_dependency(%q<rdf-spec>, ["~> 1.1"])
      s.add_dependency(%q<rdf-turtle>, ["~> 1.1"])
      s.add_dependency(%q<rdf-isomorphic>, ["~> 1.1"])
      s.add_dependency(%q<sparql>, ["~> 1.1"])
      s.add_dependency(%q<rspec>, ["= 3.2.0", "~> 3.0"])
      s.add_dependency(%q<rspec-its>, ["~> 1.0"])
      s.add_dependency(%q<webmock>, ["~> 1.17"])
    end
  else
    s.add_dependency(%q<bcp47>, [">= 0.3.3", "~> 0.3"])
    s.add_dependency(%q<rdf>, [">= 1.1.7", "~> 1.1"])
    s.add_dependency(%q<rdf-xsd>, ["~> 1.1"])
    s.add_dependency(%q<json-ld>, ["~> 1.1"])
    s.add_dependency(%q<addressable>, ["~> 2.3"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
    s.add_dependency(%q<rdf-spec>, ["~> 1.1"])
    s.add_dependency(%q<rdf-turtle>, ["~> 1.1"])
    s.add_dependency(%q<rdf-isomorphic>, ["~> 1.1"])
    s.add_dependency(%q<sparql>, ["~> 1.1"])
    s.add_dependency(%q<rspec>, ["= 3.2.0", "~> 3.0"])
    s.add_dependency(%q<rspec-its>, ["~> 1.0"])
    s.add_dependency(%q<webmock>, ["~> 1.17"])
  end
end
