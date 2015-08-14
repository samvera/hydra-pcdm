# -*- encoding: utf-8 -*-
# stub: rdf-vocab 0.8.4 ruby lib

Gem::Specification.new do |s|
  s.name = "rdf-vocab"
  s.version = "0.8.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["David Chandek-Stark", "Aaron Coburn", "Gregg Kellogg"]
  s.date = "2015-06-17"
  s.description = "Defines several standard RDF vocabularies"
  s.email = "public-rdf-ruby@w3.org"
  s.extra_rdoc_files = ["LICENSE", "README.md"]
  s.files = ["LICENSE", "README.md"]
  s.homepage = "http://ruby-rdf.github.com/rdf-vocab"
  s.licenses = ["Public Domain"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "2.4.5"
  s.summary = "A library of RDF vocabularies"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rdf>, [">= 1.1.10", "~> 1.1"])
      s.add_development_dependency(%q<rdf-reasoner>, ["~> 0.2"])
      s.add_development_dependency(%q<bundler>, ["~> 1.7"])
      s.add_development_dependency(%q<linkeddata>, ["~> 1.1"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
      s.add_development_dependency(%q<rspec-its>, ["~> 1.0"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
    else
      s.add_dependency(%q<rdf>, [">= 1.1.10", "~> 1.1"])
      s.add_dependency(%q<rdf-reasoner>, ["~> 0.2"])
      s.add_dependency(%q<bundler>, ["~> 1.7"])
      s.add_dependency(%q<linkeddata>, ["~> 1.1"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
      s.add_dependency(%q<rspec-its>, ["~> 1.0"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
    end
  else
    s.add_dependency(%q<rdf>, [">= 1.1.10", "~> 1.1"])
    s.add_dependency(%q<rdf-reasoner>, ["~> 0.2"])
    s.add_dependency(%q<bundler>, ["~> 1.7"])
    s.add_dependency(%q<linkeddata>, ["~> 1.1"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
    s.add_dependency(%q<rspec-its>, ["~> 1.0"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
  end
end
