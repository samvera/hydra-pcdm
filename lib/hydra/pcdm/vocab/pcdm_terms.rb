require 'rdf'
module RDFVocabularies
  class PCDMTerms < RDF::Vocabulary("http://pcdm.org/models#")

    # Class definitions
    term :Collection
    term :Object
    term :File

    # Property definitions
    property :hasMember
    property :hasFile
  end
end
