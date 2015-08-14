# -*- encoding: utf-8 -*-
# stub: sxp 0.1.5 ruby lib

Gem::Specification.new do |s|
  s.name = "sxp"
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Arto Bendiken", "Gregg Kellogg"]
  s.date = "2014-01-11"
  s.description = "A pure-Ruby implementation of a universal S-expression parser."
  s.email = ["arto@bendiken.net", "gregg@greggkellogg.net"]
  s.executables = ["sxp2rdf", "sxp2json", "sxp2xml", "sxp2yaml"]
  s.files = ["bin/sxp2json", "bin/sxp2rdf", "bin/sxp2xml", "bin/sxp2yaml"]
  s.homepage = "http://sxp.rubyforge.org/"
  s.licenses = ["Public Domain"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.1")
  s.rubyforge_project = "sxp"
  s.rubygems_version = "2.4.5"
  s.summary = "A pure-Ruby implementation of a universal S-expression parser."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 2.13.0"])
      s.add_development_dependency(%q<yard>, [">= 0.8.5"])
      s.add_development_dependency(%q<rdf>, [">= 1.0.0"])
    else
      s.add_dependency(%q<rspec>, [">= 2.13.0"])
      s.add_dependency(%q<yard>, [">= 0.8.5"])
      s.add_dependency(%q<rdf>, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 2.13.0"])
    s.add_dependency(%q<yard>, [">= 0.8.5"])
    s.add_dependency(%q<rdf>, [">= 1.0.0"])
  end
end
