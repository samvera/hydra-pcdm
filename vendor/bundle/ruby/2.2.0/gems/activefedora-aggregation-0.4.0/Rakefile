require "bundler/gem_tasks"


require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'jettywrapper'
Jettywrapper.hydra_jetty_version = "v8.3.1"

desc 'Spin up hydra-jetty and run specs'
task ci: ['jetty:clean'] do
  puts 'running continuous integration'
  jetty_params = Jettywrapper.load_config
  jetty_params[:startup_wait]= 90
  error = Jettywrapper.wrap(jetty_params) do
    Rake::Task['spec'].invoke
  end
  raise "test failures: #{error}" if error
end


task default: :ci
