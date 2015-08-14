require 'rdf' # @see http://rubygems.org/gems/rdf

module RDF
  ##
  # **`RDF::TriX`** is a TriX plugin for RDF.rb.
  #
  # @example Requiring the `RDF::TriX` module
  #   require 'rdf/trix'
  #
  # @example Parsing RDF statements from a TriX file
  #   RDF::TriX::Reader.open("etc/doap.xml") do |reader|
  #     reader.each_statement do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @example Serializing RDF statements into a TriX file
  #   RDF::TriX::Writer.open("etc/test.xml") do |writer|
  #     reader.each_statement do |statement|
  #       writer << statement
  #     end
  #   end
  #
  # @see http://rdf.rubyforge.org/
  # @see http://www.w3.org/2004/03/trix/
  # @see http://www.hpl.hp.com/techreports/2004/HPL-2004-56.pdf
  # @see http://swdev.nokia.com/trix/trix.html
  #
  # @author [Arto Bendiken](http://ar.to/)
  module TriX
    require 'rdf/trix/format'
    autoload :Reader,  'rdf/trix/reader'
    autoload :Writer,  'rdf/trix/writer'
    autoload :VERSION, 'rdf/trix/version'
  end # TriX
end # RDF
