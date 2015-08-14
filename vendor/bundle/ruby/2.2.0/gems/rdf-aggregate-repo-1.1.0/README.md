# RDF::AggregateRepo

An aggregate RDF::Repository supporting a subset of named graphs and zero or more named graphs mapped to the default graph.

[![Gem Version](https://badge.fury.io/rb/rdf-aggregate-repo.png)](http://badge.fury.io/rb/rdf-aggregate-repo)
[![Build Status](https://travis-ci.org/ruby-rdf/rdf-aggregate-repo.png?branch=master)](http://travis-ci.org/ruby-rdf/rdf-aggregate-repo)

## Description

Maps named graphs from one or more `RDF::Queryable` instances into a single object, allowing a specific set of _named graphs_ to be seen, as well as a _default graph_ made up from one or more _named graphs_. This is used to implement [SPARQL Datasets][].

## Examples

    require 'rdf'
    require 'rdf/nquads'
    repo = RDF::Repository.load("http://ruby-rdf.github.com/rdf/etc/doap.nq")
    
    # Instantiate a new aggregate repo based on an existing repo
    aggregate = RDF::AggregateRepo.new(repo)
    
    # Use the default graph from the repo as the default graph of the aggregate
    aggregate.add_default(false)
    
    # Use a single named graph
    aggregate.add_named(RDF::URI("http://greggkellogg.net/foaf#me"))

    # Retrieve all contexts
    aggreggate.contexts.to_a #=> [RDF::URI("http://greggkellogg.net/foaf#me")]

## Dependencies

* [Ruby](http://ruby-lang.org/) (>= 1.8.7) or (>= 1.8.1 with [Backports][])
* [RDF.rb][] (>= 1.0)

## Mailing List

* <http://lists.w3.org/Archives/Public/public-rdf-ruby/>

## Author

* [Gregg Kellogg](http://github.com/gkellogg) - <http://greggkellogg.net/>

## Contributing
This repository uses [Git Flow](https://github.com/nvie/gitflow) to mange development and release activity. All submissions _must_ be on a feature branch based on the _develop_ branch to ease staging and integration.

* Do your best to adhere to the existing coding conventions and idioms.
* Don't use hard tabs, and don't leave trailing whitespace on any line.
  Before committing, run `git diff --check` to make sure of this.
* Do document every method you add using [YARD][] annotations. Read the
  [tutorial][YARD-GS] or just look at the existing code for examples.
* Don't touch the `.gemspec` or `VERSION` files. If you need to change them,
  do so on your private branch only.
* Do feel free to add yourself to the `CREDITS` file and the
  corresponding list in the the `README`. Alphabetical order applies.
* Don't touch the `AUTHORS` file. If your contributions are significant
  enough, be assured we will eventually add you in there.
* Do note that in order for us to merge any non-trivial changes (as a rule
  of thumb, additions larger than about 15 lines of code), we need an
  explicit [public domain dedication][PDD] on record from you.

## License

This is free and unencumbered public domain software. For more information,
see <http://unlicense.org/> or the accompanying {file:UNLICENSE} file.

[RDF.rb]:           http://ruby-rdf.github.com/
[SPARQL Datasets]:  http://www.w3.org/TR/sparql11-query/#rdfDataset
[YARD]:             http://yardoc.org/
[YARD-GS]:          http://rubydoc.info/docs/yard/file/docs/GettingStarted.md
[PDD]:              http://lists.w3.org/Archives/Public/public-rdf-ruby/2010May/0013.html
