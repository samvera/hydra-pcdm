source 'https://rubygems.org'

group :development, :test do
  gem 'rubocop', require: false
  gem 'haml-lint', require: false
  gem 'rubocop-rspec', require: false
  gem 'pry' unless ENV['CI']
  gem 'pry-byebug' unless ENV['CI']
end

# Specify your gem's dependencies in hydra-pcdm.gemspec
gemspec
