# -*- encoding: utf-8 -*-
# stub: sparql 1.1.7 ruby lib

Gem::Specification.new do |s|
  s.name = "sparql"
  s.version = "1.1.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Gregg Kellogg", "Arto Bendiken"]
  s.date = "2015-05-12"
  s.description = "\n    Implements SPARQL grammar parsing to SPARQL Algebra, SPARQL Algebra processing\n    and includes SPARQL Client for accessing remote repositories."
  s.email = "public-rdf-ruby@w3.org"
  s.executables = ["sparql"]
  s.files = ["bin/sparql"]
  s.homepage = "http://github.com/ruby-rdf/sparql"
  s.licenses = ["Public Domain"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubyforge_project = "sparql"
  s.rubygems_version = "2.4.5"
  s.summary = "SPARQL Query and Update library for Ruby."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rdf>, [">= 1.1.13", "~> 1.1"])
      s.add_runtime_dependency(%q<rdf-aggregate-repo>, [">= 1.1.0", "~> 1.1"])
      s.add_runtime_dependency(%q<ebnf>, [">= 0.3.9", "~> 0.3"])
      s.add_runtime_dependency(%q<builder>, ["~> 3.2"])
      s.add_runtime_dependency(%q<sxp>, ["~> 0.1"])
      s.add_runtime_dependency(%q<sparql-client>, ["~> 1.1"])
      s.add_runtime_dependency(%q<rdf-xsd>, ["~> 1.1"])
      s.add_development_dependency(%q<sinatra>, [">= 1.4.6", "~> 1.4"])
      s.add_development_dependency(%q<rack>, ["~> 1.6"])
      s.add_development_dependency(%q<rack-test>, ["~> 0.6"])
      s.add_development_dependency(%q<linkeddata>, ["~> 1.1"])
      s.add_development_dependency(%q<rdf-spec>, ["~> 1.1"])
      s.add_development_dependency(%q<open-uri-cached>, [">= 0.0.5", "~> 0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.2"])
      s.add_development_dependency(%q<rspec-its>, ["~> 1.2"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
    else
      s.add_dependency(%q<rdf>, [">= 1.1.13", "~> 1.1"])
      s.add_dependency(%q<rdf-aggregate-repo>, [">= 1.1.0", "~> 1.1"])
      s.add_dependency(%q<ebnf>, [">= 0.3.9", "~> 0.3"])
      s.add_dependency(%q<builder>, ["~> 3.2"])
      s.add_dependency(%q<sxp>, ["~> 0.1"])
      s.add_dependency(%q<sparql-client>, ["~> 1.1"])
      s.add_dependency(%q<rdf-xsd>, ["~> 1.1"])
      s.add_dependency(%q<sinatra>, [">= 1.4.6", "~> 1.4"])
      s.add_dependency(%q<rack>, ["~> 1.6"])
      s.add_dependency(%q<rack-test>, ["~> 0.6"])
      s.add_dependency(%q<linkeddata>, ["~> 1.1"])
      s.add_dependency(%q<rdf-spec>, ["~> 1.1"])
      s.add_dependency(%q<open-uri-cached>, [">= 0.0.5", "~> 0.0"])
      s.add_dependency(%q<rspec>, ["~> 3.2"])
      s.add_dependency(%q<rspec-its>, ["~> 1.2"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
    end
  else
    s.add_dependency(%q<rdf>, [">= 1.1.13", "~> 1.1"])
    s.add_dependency(%q<rdf-aggregate-repo>, [">= 1.1.0", "~> 1.1"])
    s.add_dependency(%q<ebnf>, [">= 0.3.9", "~> 0.3"])
    s.add_dependency(%q<builder>, ["~> 3.2"])
    s.add_dependency(%q<sxp>, ["~> 0.1"])
    s.add_dependency(%q<sparql-client>, ["~> 1.1"])
    s.add_dependency(%q<rdf-xsd>, ["~> 1.1"])
    s.add_dependency(%q<sinatra>, [">= 1.4.6", "~> 1.4"])
    s.add_dependency(%q<rack>, ["~> 1.6"])
    s.add_dependency(%q<rack-test>, ["~> 0.6"])
    s.add_dependency(%q<linkeddata>, ["~> 1.1"])
    s.add_dependency(%q<rdf-spec>, ["~> 1.1"])
    s.add_dependency(%q<open-uri-cached>, [">= 0.0.5", "~> 0.0"])
    s.add_dependency(%q<rspec>, ["~> 3.2"])
    s.add_dependency(%q<rspec-its>, ["~> 1.2"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
  end
end
