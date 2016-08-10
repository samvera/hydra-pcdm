# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hydra/pcdm/version'

Gem::Specification.new do |spec|
  spec.name          = 'hydra-pcdm'
  spec.version       = Hydra::PCDM::VERSION
  spec.authors       = ['E. Lynette Rayle']
  spec.email         = ['elr37@cornell.edu']
  spec.summary       = 'Portland Common Data Model (PCDM)'
  spec.description   = 'Portland Common Data Model (PCDM)'
  spec.homepage      = 'https://github.com/projecthydra-labs/hydra-pcdm'
  spec.license       = 'APACHE2'
  spec.required_ruby_version = '>= 1.9.3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'active-fedora', '>= 10', '< 12'
  spec.add_dependency 'mime-types', '>= 1'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'fcrepo_wrapper', '~> 0.1'
  spec.add_development_dependency 'solr_wrapper', '~> 0.4'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rspec'
end
