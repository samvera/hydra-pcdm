# -*- encoding: utf-8 -*-
# stub: rdf-reasoner 0.2.2 ruby lib

Gem::Specification.new do |s|
  s.name = "rdf-reasoner"
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Gregg Kellogg"]
  s.date = "2015-05-27"
  s.description = "Reasons over RDFS/OWL vocabularies to generate statements which are entailed based on base RDFS/OWL rules along with vocabulary information. It can also be used to ask specific questions, such as if a given object is consistent with the vocabulary ruleset. This can be used to implement SPARQL Entailment Regimes."
  s.email = "public-rdf-ruby@w3.org"
  s.homepage = "http://github.com/gkellogg/rdf-reasoner"
  s.licenses = ["Public Domain"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.4.5"
  s.summary = "RDFS/OWL Reasoner for RDF.rb"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rdf>, [">= 1.1.4.2", "~> 1.1"])
      s.add_runtime_dependency(%q<rdf-xsd>, ["~> 1.1"])
      s.add_runtime_dependency(%q<rdf-turtle>, ["~> 1.1"])
      s.add_runtime_dependency(%q<rdf-vocab>, ["~> 0.8"])
      s.add_development_dependency(%q<linkeddata>, ["~> 1.1"])
      s.add_development_dependency(%q<equivalent-xml>, ["~> 0.4"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
    else
      s.add_dependency(%q<rdf>, [">= 1.1.4.2", "~> 1.1"])
      s.add_dependency(%q<rdf-xsd>, ["~> 1.1"])
      s.add_dependency(%q<rdf-turtle>, ["~> 1.1"])
      s.add_dependency(%q<rdf-vocab>, ["~> 0.8"])
      s.add_dependency(%q<linkeddata>, ["~> 1.1"])
      s.add_dependency(%q<equivalent-xml>, ["~> 0.4"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
    end
  else
    s.add_dependency(%q<rdf>, [">= 1.1.4.2", "~> 1.1"])
    s.add_dependency(%q<rdf-xsd>, ["~> 1.1"])
    s.add_dependency(%q<rdf-turtle>, ["~> 1.1"])
    s.add_dependency(%q<rdf-vocab>, ["~> 0.8"])
    s.add_dependency(%q<linkeddata>, ["~> 1.1"])
    s.add_dependency(%q<equivalent-xml>, ["~> 0.4"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
  end
end
