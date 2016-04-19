source 'https://rubygems.org'

group :development, :test do
  gem 'rubocop', '~> 0.37.0', require: false
  gem 'rubocop-rspec', '~> 1.3.1', require: false
  gem 'pry' unless ENV['CI']
  gem 'pry-byebug' unless ENV['CI']
end

# Specify your gem's dependencies in hydra-pcdm.gemspec
gemspec
