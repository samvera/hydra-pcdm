# Hydra::PCDM

[![Version](https://badge.fury.io/rb/hydra-pcdm.png)](http://badge.fury.io/rb/hydra-pcdm)
[![Build Status](https://travis-ci.org/projecthydra/hydra-pcdm.svg?branch=master)](https://travis-ci.org/projecthydra/hydra-pcdm)
[![Coverage Status](https://coveralls.io/repos/projecthydra/hydra-pcdm/badge.svg?branch=master)](https://coveralls.io/r/projecthydra/hydra-pcdm?branch=master)
[![Code Climate](https://codeclimate.com/github/projecthydra/hydra-pcdm/badges/gpa.svg)](https://codeclimate.com/github/projecthydra/hydra-pcdm)
[![Apache 2.0 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)
[![Contribution Guidelines](http://img.shields.io/badge/CONTRIBUTING-Guidelines-blue.svg)](./CONTRIBUTING.md)
[![API Docs](http://img.shields.io/badge/API-docs-blue.svg)](http://rubydoc.info/gems/hydra-pcdm)

Hydra implementation of the Portland Common Data Model (PCDM)

## Installation

Add these lines to your application's Gemfile:

```ruby
  gem 'active-fedora', '~> 9.3'
  gem 'hydra-pcdm', '~> 0.4'
```

And then execute:

    $ bundle install

Or install it yourself:

    $ gem install hydra-pcdm

## Access Controls

We are using [Web ACL](http://www.w3.org/wiki/WebAccessControl) as implemented in [hydra-access-controls](https://github.com/projecthydra/hydra-head/tree/master/hydra-access-controls).

## Portland Common Data Model

Reference: [Portland Common Data Model](https://github.com/duraspace/pcdm/wiki)

### Model Definition

![PCDM Model Definition](https://raw.githubusercontent.com/wiki/duraspace/pcdm/images/coll-object-file.png)

## Usage

Hydra::PCDM provides three core classes:

```
Hydra::PCDM::Object
Hydra::PCDM::Collection
Hydra::PCDM::File
```

A `Hydra::PCDM::File` is a NonRDFSource (in [LDP](http://www.w3.org/TR/ldp/) parlance) &emdash; a bitstream. You can use this to store content. A PCDM::File is contained by a PCDM::Object. A `File` may have some attached technical metadata, but no descriptive metadata. A `Hydra::PCDM::Object` may contain `File`s, may have descriptive metadata, and may declare other `Object`s as members (for complex object hierarchies). A `Hydra::PCDM::Collection` may contain other `Collection`s or `Object`s but may not directly contain `File`s. A `Collection` may also have descriptive metadata.

Typically, usage involves extending the behavior provided by this gem. In your application you can write something like this:

```ruby
class Book < ActiveFedora::Base
  include Hydra::PCDM::ObjectBehavior
end

class Collection < ActiveFedora::Base
  include Hydra::PCDM::CollectionBehavior
end

collection = Collection.create
book = Book.create

collection.members = [book]
# or: collection.members << book
collection.save

file = book.files.build
file.content = "The quick brown fox jumped over the lazy dog."
book.save
```

## Contributing

If you'd like to contribute to this effort, please check out the [Contributing Guide](CONTRIBUTING.md)
