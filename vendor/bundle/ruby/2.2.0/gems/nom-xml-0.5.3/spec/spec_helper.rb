if ENV['COVERAGE'] and RUBY_VERSION =~ /^1.9/
  require 'simplecov'
  SimpleCov.start
end

require 'rspec'
require 'nom'
require 'equivalent-xml/rspec_matchers'

RSpec.configure do |config|

end

