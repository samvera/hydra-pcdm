# -*- encoding: utf-8 -*-
# stub: rubocop-rspec 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rubocop-rspec"
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ian MacLeod", "Nils Gemeinhardt"]
  s.date = "2015-04-23"
  s.description = "    Code style checking for RSpec files.\n    A plugin for the RuboCop code style enforcing & linting tool.\n"
  s.email = ["ian@nevir.net", "git@nilsgemeinhardt.de"]
  s.extra_rdoc_files = ["MIT-LICENSE.md", "README.md"]
  s.files = ["MIT-LICENSE.md", "README.md"]
  s.homepage = "http://github.com/nevir/rubocop-rspec"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.4.5"
  s.summary = "Code style checking for RSpec files"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rubocop>, ["~> 0.24"])
      s.add_development_dependency(%q<rake>, ["~> 10.1"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.8"])
    else
      s.add_dependency(%q<rubocop>, ["~> 0.24"])
      s.add_dependency(%q<rake>, ["~> 10.1"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
      s.add_dependency(%q<simplecov>, ["~> 0.8"])
    end
  else
    s.add_dependency(%q<rubocop>, ["~> 0.24"])
    s.add_dependency(%q<rake>, ["~> 10.1"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
    s.add_dependency(%q<simplecov>, ["~> 0.8"])
  end
end
