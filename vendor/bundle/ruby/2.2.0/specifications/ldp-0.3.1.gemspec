# -*- encoding: utf-8 -*-
# stub: ldp 0.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "ldp"
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Chris Beer"]
  s.date = "2015-05-12"
  s.description = "Linked Data Platform client library"
  s.email = ["chris@cbeer.info"]
  s.executables = ["ldp"]
  s.files = ["bin/ldp"]
  s.homepage = "https://github.com/projecthydra/ldp"
  s.licenses = ["APACHE2"]
  s.rubygems_version = "2.4.5"
  s.summary = "Linked Data Platform client library"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<faraday>, [">= 0"])
      s.add_runtime_dependency(%q<linkeddata>, [">= 1.1"])
      s.add_runtime_dependency(%q<http_logger>, [">= 0"])
      s.add_runtime_dependency(%q<slop>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<faraday>, [">= 0"])
      s.add_dependency(%q<linkeddata>, [">= 1.1"])
      s.add_dependency(%q<http_logger>, [">= 0"])
      s.add_dependency(%q<slop>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<faraday>, [">= 0"])
    s.add_dependency(%q<linkeddata>, [">= 1.1"])
    s.add_dependency(%q<http_logger>, [">= 0"])
    s.add_dependency(%q<slop>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
