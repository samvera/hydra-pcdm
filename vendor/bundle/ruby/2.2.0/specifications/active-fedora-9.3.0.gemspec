# -*- encoding: utf-8 -*-
# stub: active-fedora 9.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "active-fedora"
  s.version = "9.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Matt Zumwalt", "McClain Looney", "Justin Coyne"]
  s.date = "2015-08-07"
  s.description = "ActiveFedora provides for creating and managing objects in the Fedora Repository Architecture."
  s.email = ["matt.zumwalt@yourmediashelf.com"]
  s.extra_rdoc_files = ["LICENSE", "README.md"]
  s.files = ["LICENSE", "README.md"]
  s.homepage = "https://github.com/projecthydra/active_fedora"
  s.licenses = ["APACHE2"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.4.5"
  s.summary = "A convenience libary for manipulating documents in the Fedora Repository."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rsolr>, ["~> 1.0.10"])
      s.add_runtime_dependency(%q<om>, ["~> 3.1"])
      s.add_runtime_dependency(%q<nom-xml>, [">= 0.5.1"])
      s.add_runtime_dependency(%q<activesupport>, [">= 4.1.0"])
      s.add_runtime_dependency(%q<active-triples>, ["~> 0.7.1"])
      s.add_runtime_dependency(%q<rdf-rdfxml>, ["~> 1.1.0"])
      s.add_runtime_dependency(%q<linkeddata>, [">= 0"])
      s.add_runtime_dependency(%q<deprecation>, [">= 0"])
      s.add_runtime_dependency(%q<ldp>, ["~> 0.3.1"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<jettywrapper>, [">= 2.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
      s.add_development_dependency(%q<rspec-its>, [">= 0"])
      s.add_development_dependency(%q<equivalent-xml>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.7.1"])
    else
      s.add_dependency(%q<rsolr>, ["~> 1.0.10"])
      s.add_dependency(%q<om>, ["~> 3.1"])
      s.add_dependency(%q<nom-xml>, [">= 0.5.1"])
      s.add_dependency(%q<activesupport>, [">= 4.1.0"])
      s.add_dependency(%q<active-triples>, ["~> 0.7.1"])
      s.add_dependency(%q<rdf-rdfxml>, ["~> 1.1.0"])
      s.add_dependency(%q<linkeddata>, [">= 0"])
      s.add_dependency(%q<deprecation>, [">= 0"])
      s.add_dependency(%q<ldp>, ["~> 0.3.1"])
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<jettywrapper>, [">= 2.0.0"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
      s.add_dependency(%q<rspec-its>, [">= 0"])
      s.add_dependency(%q<equivalent-xml>, [">= 0"])
      s.add_dependency(%q<simplecov>, ["~> 0.7.1"])
    end
  else
    s.add_dependency(%q<rsolr>, ["~> 1.0.10"])
    s.add_dependency(%q<om>, ["~> 3.1"])
    s.add_dependency(%q<nom-xml>, [">= 0.5.1"])
    s.add_dependency(%q<activesupport>, [">= 4.1.0"])
    s.add_dependency(%q<active-triples>, ["~> 0.7.1"])
    s.add_dependency(%q<rdf-rdfxml>, ["~> 1.1.0"])
    s.add_dependency(%q<linkeddata>, [">= 0"])
    s.add_dependency(%q<deprecation>, [">= 0"])
    s.add_dependency(%q<ldp>, ["~> 0.3.1"])
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<jettywrapper>, [">= 2.0.0"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
    s.add_dependency(%q<rspec-its>, [">= 0"])
    s.add_dependency(%q<equivalent-xml>, [">= 0"])
    s.add_dependency(%q<simplecov>, ["~> 0.7.1"])
  end
end
