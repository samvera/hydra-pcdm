# -*- encoding: utf-8 -*-
# stub: activefedora-aggregation 0.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "activefedora-aggregation"
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Justin Coyne"]
  s.date = "2015-08-07"
  s.email = ["justin@curationexperts.com"]
  s.homepage = "http://github.org/curationexperts/activefedora-aggregation"
  s.licenses = ["APACHE2"]
  s.rubygems_version = "2.4.5"
  s.summary = "Aggregations for active-fedora"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<active-fedora>, [">= 0"])
      s.add_runtime_dependency(%q<rdf-vocab>, ["~> 0.8.1"])
      s.add_development_dependency(%q<bundler>, ["~> 1.8"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.2"])
      s.add_development_dependency(%q<jettywrapper>, [">= 0"])
      s.add_development_dependency(%q<pry-byebug>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<active-fedora>, [">= 0"])
      s.add_dependency(%q<rdf-vocab>, ["~> 0.8.1"])
      s.add_dependency(%q<bundler>, ["~> 1.8"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<rspec>, ["~> 3.2"])
      s.add_dependency(%q<jettywrapper>, [">= 0"])
      s.add_dependency(%q<pry-byebug>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<active-fedora>, [">= 0"])
    s.add_dependency(%q<rdf-vocab>, ["~> 0.8.1"])
    s.add_dependency(%q<bundler>, ["~> 1.8"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<rspec>, ["~> 3.2"])
    s.add_dependency(%q<jettywrapper>, [">= 0"])
    s.add_dependency(%q<pry-byebug>, [">= 0"])
  end
end
