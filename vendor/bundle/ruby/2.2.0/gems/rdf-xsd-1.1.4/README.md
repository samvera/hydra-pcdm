# Extended XSD Datatypes for RDF.rb

This gem adds additional RDF::Literal subclasses for extended [XSD datatypes][]

* <http://github.com/ruby-rdf/rdf-xsd>

[![Gem Version](https://badge.fury.io/rb/rdf-xsd.png)](http://badge.fury.io/rb/rdf-xsd)
[![Build Status](https://travis-ci.org/ruby-rdf/rdf-xsd.png?branch=master)](http://travis-ci.org/ruby-rdf/rdf-xsd)

## Features

* Additional xsd:integer subtypes
* xsd:float based on xsd:double
* xsd:duration
* rdf:XMLLiteral
* XML Exclusive Canonicalization (Nokogiri & REXML)
* XML Literal comparisions (EquivalentXml, ActiveSupport or String)

## Examples

    require 'rdf'
    require 'rdf/xsd'

## Dependencies
* [Ruby](http://ruby-lang.org/) (>= 1.9.2)
* [RDF.rb](http://rubygems.org/gems/rdf) (>= 1.1)
* Soft dependency on [Nokogiri](http://rubygems.org/gems/nokogiri) (>= 1.5.9)
* Soft dependency on [EquivalentXML](http://rubygems.org/gems/equivalent-xml) (>= 0.2.8)
* Soft dependency on [ActiveSupport](http://rubygems.org/gems/activesupport) (>= 3.0.0)

## Documentation
Full documentation available on [Rubydoc.info][XSD doc]

### Principle Classes
* {RDF::Literal::Base64Binary}
* {RDF::Literal::Duration}
* {RDF::Literal::Float}
* {RDF::Literal::HexBinary}
* {RDF::Literal::NonPositiveInteger}
  * {RDF::Literal::NegativeInteger}
* {RDF::Literal::Long}
  * {RDF::Literal::Int}
    * {RDF::Literal::Short}
      * {RDF::Literal::Byte}
* {RDF::Literal::NonNegativeInteger}
  * {RDF::Literal::PositiveInteger}
  * {RDF::Literal::UnsignedLong}
    * {RDF::Literal::UnsignedInt}
      * {RDF::Literal::UnsignedShort}
        * {RDF::Literal::UnsignedByte}
* {RDF::Literal::YearMonth}
* {RDF::Literal::Year}
* {RDF::Literal::MonthDay}
* {RDF::Literal::Month}
* {RDF::Literal::Day}
* {RDF::Literal::XML}

## Installation

The recommended installation method is via [RubyGems](http://rubygems.org/).
To install the latest official release of the `RDF::XSD` gem, do:

    % [sudo] gem install rdf-xsd

## Mailing List

* <http://lists.w3.org/Archives/Public/public-rdf-ruby/>

## Author

* [Gregg Kellogg](http://github.com/gkellogg) - <http://greggkellogg.net/>

## Contributing
This repository uses [Git Flow](https://github.com/nvie/gitflow) to mange development and release activity. All submissions _must_ be on a feature branch based on the _develop_ branch to ease staging and integration.

* Do your best to adhere to the existing coding conventions and idioms.
* Don't use hard tabs, and don't leave trailing whitespace on any line.
* Do document every method you add using [YARD][] annotations. Read the
  [tutorial][YARD-GS] or just look at the existing code for examples.
* Don't touch the `.gemspec`, `VERSION` or `AUTHORS` files. If you need to
  change them, do so on your private branch only.
* Do feel free to add yourself to the `CREDITS` file and the corresponding
  list in the the `README`. Alphabetical order applies.
* Do note that in order for us to merge any non-trivial changes (as a rule
  of thumb, additions larger than about 15 lines of code), we need an
  explicit [public domain dedication][PDD] on record from you.

## License

This is free and unencumbered public domain software. For more information,
see <http://unlicense.org/> or the accompanying {file:UNLICENSE} file.

Portions of tests are derived from [W3C DAWG tests](http://www.w3.org/2001/sw/DataAccess/tests/) and have [other licensing terms](http://www.w3.org/2001/sw/DataAccess/tests/data-r2/LICENSE).

[Ruby]:       http://ruby-lang.org/
[RDF]:        http://www.w3.org/RDF/
[YARD]:       http://yardoc.org/
[YARD-GS]:    http://rubydoc.info/docs/yard/file/docs/GettingStarted.md
[PDD]:        http://lists.w3.org/Archives/Public/public-rdf-ruby/2010May/0013.html
[Backports]:  http://rubygems.org/gems/backports
[XSD Datatypes]: http://www.w3.org/TR/2004/REC-xmlschema-2-20041028/#built-in-datatypes