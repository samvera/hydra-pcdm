# -*- encoding: utf-8 -*-
# stub: rdf 1.1.14 ruby lib

Gem::Specification.new do |s|
  s.name = "rdf"
  s.version = "1.1.14"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Arto Bendiken", "Ben Lavender", "Gregg Kellogg"]
  s.date = "2015-06-08"
  s.description = "RDF.rb is a pure-Ruby library for working with Resource Description Framework (RDF) data."
  s.email = "public-rdf-ruby@w3.org"
  s.executables = ["rdf"]
  s.files = ["bin/rdf"]
  s.homepage = "http://ruby-rdf.github.com/"
  s.licenses = ["Public Domain"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubyforge_project = "rdf"
  s.rubygems_version = "2.4.5"
  s.summary = "A Ruby library for working with Resource Description Framework (RDF) data."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<link_header>, [">= 0.0.8", "~> 0.0"])
      s.add_development_dependency(%q<rdf-spec>, [">= 1.1.13", "~> 1.1"])
      s.add_development_dependency(%q<rdf-rdfxml>, ["~> 1.1"])
      s.add_development_dependency(%q<rdf-rdfa>, ["~> 1.1"])
      s.add_development_dependency(%q<rdf-turtle>, ["~> 1.1"])
      s.add_development_dependency(%q<rdf-xsd>, ["~> 1.1"])
      s.add_development_dependency(%q<rest-client>, ["~> 1.7"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
      s.add_development_dependency(%q<rspec-its>, ["~> 1.0"])
      s.add_development_dependency(%q<webmock>, ["~> 1.17"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
      s.add_development_dependency(%q<faraday>, ["~> 0.9"])
      s.add_development_dependency(%q<faraday_middleware>, ["~> 0.9"])
    else
      s.add_dependency(%q<link_header>, [">= 0.0.8", "~> 0.0"])
      s.add_dependency(%q<rdf-spec>, [">= 1.1.13", "~> 1.1"])
      s.add_dependency(%q<rdf-rdfxml>, ["~> 1.1"])
      s.add_dependency(%q<rdf-rdfa>, ["~> 1.1"])
      s.add_dependency(%q<rdf-turtle>, ["~> 1.1"])
      s.add_dependency(%q<rdf-xsd>, ["~> 1.1"])
      s.add_dependency(%q<rest-client>, ["~> 1.7"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
      s.add_dependency(%q<rspec-its>, ["~> 1.0"])
      s.add_dependency(%q<webmock>, ["~> 1.17"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
      s.add_dependency(%q<faraday>, ["~> 0.9"])
      s.add_dependency(%q<faraday_middleware>, ["~> 0.9"])
    end
  else
    s.add_dependency(%q<link_header>, [">= 0.0.8", "~> 0.0"])
    s.add_dependency(%q<rdf-spec>, [">= 1.1.13", "~> 1.1"])
    s.add_dependency(%q<rdf-rdfxml>, ["~> 1.1"])
    s.add_dependency(%q<rdf-rdfa>, ["~> 1.1"])
    s.add_dependency(%q<rdf-turtle>, ["~> 1.1"])
    s.add_dependency(%q<rdf-xsd>, ["~> 1.1"])
    s.add_dependency(%q<rest-client>, ["~> 1.7"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
    s.add_dependency(%q<rspec-its>, ["~> 1.0"])
    s.add_dependency(%q<webmock>, ["~> 1.17"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
    s.add_dependency(%q<faraday>, ["~> 0.9"])
    s.add_dependency(%q<faraday_middleware>, ["~> 0.9"])
  end
end
