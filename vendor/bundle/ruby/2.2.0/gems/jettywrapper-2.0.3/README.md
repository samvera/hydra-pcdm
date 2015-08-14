# Jettywrapper [![Version](https://badge.fury.io/gh/projecthydra%2Fjettywrapper.png)](http://badge.fury.io/gh/projecthydra%2Fjettywrapper) [![Build Status](https://travis-ci.org/projecthydra/jettywrapper.png?branch=master)](https://travis-ci.org/projecthydra/jettywrapper)

This gem is designed to make it easier to integrate a jetty servlet container into a rails project.  
Jettywrapper provides rake tasks for starting and stopping jetty, as well as the method `Jettywrapper.wrap` that will start
the server before the block and stop the server after the block, which is useful for automated testing.

By default, Jettywrapper is designed to work with Rails projects that use the Hydra gem, and downloads an instance of a 
[hydra-jetty](https://github.com/projecthydra/hydra-jetty) project zipfile. However, it can be configured to 
download any Jetty-based project on Github.

Jettywrapper supports

* ruby 2.0.0
* ruby 1.9.3 
* ruby 1.8.7 
* ree  1.8.7
* jruby 1.6.6+

## Configuring Jettywrapper

Jettywrapper starts the process with a list of options that you can specify in `config/jetty.yml`, otherwise a default is used.
You can provide a per-environment configuration, or you can have a default configuration which will be used when a per-environment
configuration is not specified. Such a configuration might look like:

    default:
      jetty_port: 8983
      java_opts:
        - "-XX:MaxPermSize=128m"
        - "-Xmx256m"

You can also configure a specific version of hydra-jetty. This is placed in your codebase, usually in a rake task 

    Jettywrapper.hydra_jetty_version = "v1.2.3"

Alternatively, you can use a completely different Jetty-based repository, Hydra-related or not

    Jettywrapper.url = "https://github.com/myorg/my-jetty/archive/master.zip"

The name of the zip file can either be a branch name, such as master or develop, or the tag name of a released version.
Basically, any url that Github provides as a *.zip file will work.

## Example rake task

```ruby
require 'jettywrapper'
Jettywrapper.url = "https://github.com/myorg/my-jetty/archive/testing-feature-branch.zip"
desc "Hudson build"
task :hudson do
  jetty_params = Jettywrapper.load_config.merge({:jetty_home => File.expand_path(File.dirname(__FILE__) + '/../jetty')})
  error = Jettywrapper.wrap(jetty_params) do  
    Rake::Task["spec"].invoke
  end
  raise "test failures: #{error}" if error
end
```

## Testing the gem 

If you haven't already, clone the git repository

    git clone git@github.com:projecthydra/jettywrapper.git
    cd jettywrapper

Install the gems

    bundle install

Run the tests

    rake 
