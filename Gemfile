source 'https://rubygems.org'

group :development, :test do
  gem 'rubocop', require: false
  gem 'haml-lint', require: false
  gem 'rubocop-rspec', require: false
  gem 'pry' unless ENV['CI']
  gem 'pry-byebug' unless ENV['CI']
end

gem 'activefedora-aggregation', github: 'projecthydra-labs/activefedora-aggregation'

# Specify your gem's dependencies in hydra-pcdm.gemspec
gemspec
