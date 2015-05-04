# Hydra::PCDM

Hydra implementation of Portland Common Data Models (PCDM)

## Installation

Add this line to your application's Gemfile:

    gem 'hydra-pcdm', :git => 'git@github.com:projecthydra-labs/hydra-pcdm.git', :branch => 'master'
    
Substitute another branch name for 'master' to test out a branch under development.    
<!-- Temporarily comment out until gem is published.
    gem 'hydra-pcdm' 
-->

And then execute:

    $ bundle
<!-- Temporarily comment out until gem is published.
Or install it yourself as:

    $ gem install hydra-pcdm
-->

## Access Controls
We are using [Web ACL](http://www.w3.org/wiki/WebAccessControl) as implemented by [hydra-access](https://github.com/projecthydra/hydra-head/tree/master/hydra-access-controls) controls

## PCDM Model

Reference:  [Portland Common Data Model](https://wiki.duraspace.org/x/9IoOB)


### Model Definition

![PCDM Model Definition](https://wiki.duraspace.org/download/attachments/68061940/coll-object-file.png?version=1&modificationDate=1425932362178&api=v2)


### Example

To test the model and provide clarity we have included a sample mode that exercises the interfaces provided by the gem.
The sample model may change over time to reflect the state of the gam and what it supports.  
(TODO: Currently there is no code in the gem so it does not support any model including the example.)
![Sandwich Objet Model](https://docs.google.com/drawings/d/1wI4H3AH9pdIPllKIMO356c1cFHUN57azDlgIqMVODSw/pub?w=1369&h=727)

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/hydra-pcdm/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
