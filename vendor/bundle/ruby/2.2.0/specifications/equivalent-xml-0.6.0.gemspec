# -*- encoding: utf-8 -*-
# stub: equivalent-xml 0.6.0 ruby lib

Gem::Specification.new do |s|
  s.name = "equivalent-xml"
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Michael B. Klein"]
  s.date = "2015-04-21"
  s.description = "Compares two XML Nodes (Documents, etc.) for certain semantic equivalencies. \n    Currently written for Nokogiri, but with an eye toward supporting multiple XML libraries"
  s.email = "mbklein@gmail.com"
  s.extra_rdoc_files = ["LICENSE.txt", "README.md"]
  s.files = ["LICENSE.txt", "README.md"]
  s.homepage = "http://github.com/mbklein/equivalent-xml"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "Easy equivalency tests for Ruby XML"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.3"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.4"])
      s.add_development_dependency(%q<rake>, [">= 0.9.0"])
      s.add_development_dependency(%q<rdoc>, [">= 3.12"])
    else
      s.add_dependency(%q<nokogiri>, [">= 1.4.3"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 1.2.4"])
      s.add_dependency(%q<rake>, [">= 0.9.0"])
      s.add_dependency(%q<rdoc>, [">= 3.12"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.4.3"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 1.2.4"])
    s.add_dependency(%q<rake>, [">= 0.9.0"])
    s.add_dependency(%q<rdoc>, [">= 3.12"])
  end
end
