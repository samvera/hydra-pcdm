# -*- encoding: utf-8 -*-
# stub: rdf-xsd 1.1.4 ruby lib

Gem::Specification.new do |s|
  s.name = "rdf-xsd"
  s.version = "1.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Gregg", "Kellogg"]
  s.date = "2015-07-09"
  s.description = "Adds RDF::Literal subclasses for extended XSD datatypes."
  s.email = "public-rdf-ruby@w3.org"
  s.homepage = "http://ruby-rdf.github.com/rdf-xsd"
  s.licenses = ["Public Domain"]
  s.post_install_message = "\n    For best results, use nokogiri and equivalent-xml gems as well.\n    These are not hard requirements to preserve pure-ruby dependencies.\n  "
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubyforge_project = "rdf-xsd"
  s.rubygems_version = "2.4.5"
  s.summary = "Extended XSD Datatypes for RDF.rb."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rdf>, [">= 1.1.9", "~> 1.1"])
      s.add_development_dependency(%q<activesupport>, ["~> 4.1"])
      s.add_development_dependency(%q<i18n>, ["~> 0.6"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
      s.add_development_dependency(%q<rspec-its>, ["~> 1.0"])
      s.add_development_dependency(%q<rdf-spec>, ["~> 1.1"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
    else
      s.add_dependency(%q<rdf>, [">= 1.1.9", "~> 1.1"])
      s.add_dependency(%q<activesupport>, ["~> 4.1"])
      s.add_dependency(%q<i18n>, ["~> 0.6"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
      s.add_dependency(%q<rspec-its>, ["~> 1.0"])
      s.add_dependency(%q<rdf-spec>, ["~> 1.1"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
    end
  else
    s.add_dependency(%q<rdf>, [">= 1.1.9", "~> 1.1"])
    s.add_dependency(%q<activesupport>, ["~> 4.1"])
    s.add_dependency(%q<i18n>, ["~> 0.6"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
    s.add_dependency(%q<rspec-its>, ["~> 1.0"])
    s.add_dependency(%q<rdf-spec>, ["~> 1.1"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
  end
end
