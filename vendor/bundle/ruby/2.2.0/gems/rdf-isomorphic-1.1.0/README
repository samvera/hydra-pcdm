# RDF Isomorphism

This is an [RDF.rb][] plugin for RDF Isomorphism functionality for RDF::Enumerables.
That includes RDF::Repository, RDF::Graph, query results, and more.

For more information about [RDF.rb][], see <http://rdf.rubyforge.org>

[![Gem Version](https://badge.fury.io/rb/rdf-isomorphic.png)](http://badge.fury.io/rb/rdf-isomorphic)
[![Build Status](https://travis-ci.org/ruby-rdf/rdf-isomorphic.png)](https://travis-ci.org/ruby-rdf/rdf-isomorphic)

## Synopsis:

    require 'rdf/isomorphic'
    require 'rdf/ntriples'


    a = RDF::Repository.load './tests/isomorphic/test1/test1-1.nt'
    a.first
    # < RDF::Statement:0xd344c4(<http://example.org/a> <http://example.org/prop> <_:abc> .) >
    
    b = RDF::Repository.load './tests/isomorphic/test1/test1-2.nt'
    b.first
    # < RDF::Statement:0xd3801a(<http://example.org/a> <http://example.org/prop> <_:testing> .) >

    a.isomorphic_with? b
    # true

    a.bijection_to b
    # { #<RDF::Node:0xd345a0(_:abc)>=>#<RDF::Node:0xd38574(_:testing)> }


## Algorithm

The algorithm used here is very similar to the one described by Jeremy Carroll
in <http://www.hpl.hp.com/techreports/2001/HPL-2001-293.pdf>.  See
<http://blog.datagraph.org/2010/03/rdf-isomorphism>.

Generally speaking, the Carroll algorithm is a very good fit for RDF graphs. It
is a specialization of the naive factorial-time test for graph isomorphism,
wherein non-anonymous RDF data lets us eliminate vast quantities of options well
before we try them.  Pathological cases, such as graphs which only contain
anonymous resources, may experience poor performance.

### Equality

Although it was considered to provide `==` to mean isomorphic, RDF isomorphism
can sometimes be a factorial-complexity problem and it seemed better to perhaps
not overwrite such a commonly used method for that.  But it's really useful for
specs in RDF libraries.  Try this in your tests:

    require 'rdf/isomorphic'
    module RDF
      module Isomorphic
        alias_method :==, :isomorphic_with?
      end
    end
    
    describe 'something' do
      context 'does' do
        it 'should be equal' do
          repository_a.should == repository_b
        end
      end
    end

### Information
 * Author: Ben Lavender <blavender@gmail.com> - <http://bhuga.net>
 * Author: Arto Bendiken <arto.bendiken@gmail.com> - <http://ar.to>
 * Source: <http://github.com/bhuga/RDF-Isomorphic>
 * Issues: <http://github.com/bhuga/RDF-Isomorphic/issues>

### See also
 * RDF.rb: <http://ruby-rdf.github.com>
 * RDF.rb source: <http://github.com/ruby-rdf/rdf>

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
[YARD]:             http://yardoc.org/
[YARD-GS]:          http://rubydoc.info/docs/yard/file/docs/GettingStarted.md
[PDD]:              http://lists.w3.org/Archives/Public/public-rdf-ruby/2010May/0013.html
