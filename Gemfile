source 'https://rubygems.org'

group :development, :test do
  gem 'rubocop', require: false
  gem 'haml-lint', require: false
  gem 'rubocop-rspec', require: false
  gem 'pry' unless ENV['CI']
  gem 'pry-byebug' unless ENV['CI']
end

gem 'activefedora-aggregation', github: 'projecthydra-labs/activefedora-aggregation'
gem 'active-fedora', github: 'projecthydra/active_fedora', branch: 'indirect_ids_reader'

# Specify your gem's dependencies in hydra-pcdm.gemspec
gemspec
