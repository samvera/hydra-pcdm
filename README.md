# Hydra::PCDM
[![Build Status](https://travis-ci.org/projecthydra-labs/hydra-pcdm.svg?branch=master)](https://travis-ci.org/projecthydra-labs/hydra-pcdm)
[![Coverage Status](https://coveralls.io/repos/projecthydra-labs/hydra-pcdm/badge.svg?branch=master)](https://coveralls.io/r/projecthydra-labs/hydra-pcdm?branch=master)

Hydra implementation of Portland Common Data Models (PCDM)

## Installation

Add these lines to your application's Gemfile:

```ruby
  gem 'active-fedora', github: 'projecthydra/active_fedora' # hydra-pcdm requires an unreleased version of ActiveFedora
  gem 'hydra-pcdm', github: 'projecthydra-labs/hydra-pcdm'
```

Substitute another branch name for 'master' to test out a branch under development.    
<!-- Temporarily comment out until gem is published.
    gem 'hydra-pcdm' 
-->

And then execute:
```
    $ bundle
```
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

![Sandwich Objet Model](https://docs.google.com/drawings/d/1wI4H3AH9pdIPllKIMO356c1cFHUN57azDlgIqMVODSw/pub?w=1369&h=727)

## Usage

Hydra-pcdm provides three classes:
```
Hydra::PCDM::Object
Hydra::PCDM::Collection
Hydra::PCDM::File
```

A `Hydra::PCDM::File` is a NonRDFSource &emdash; a bitstream.  You can use this to store content. A PCDM::File is contained by a PCDM::Object. A `File` has some attached technical metadata, but no descriptive metadata.  A `Hydra::PCDM::Object` contains files and other objects and may have descriptive metadata.  A `Hydra::PCDM::Collection` can contain other `Collection`s or `Object`s but not `File`s.  A `Collection` also may have descriptive metadata.

Typically usage involves extending the behavior provided by this gem. In your application you can write something like this:

```ruby

class Book < ActiveFedora::Base
  include Hydra::PCDM::ObjectBehavior
end

class Collection < ActiveFedora::Base
  include Hydra::PCDM::CollectionBehavior
end

c1 = Collection.create
b1 = Book.create

c1.members = [b1]
# c1.members << b1 # This should work in the future
c1.save

f1 = b1.files.build
f1.content = "The quick brown fox jumped over the lazy dog."
b1.save
```

## How to contribute
If you'd like to contribute to this effort, please check out the [Contributing Guide](CONTRIBUTING.md)
