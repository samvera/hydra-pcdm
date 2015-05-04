require 'rdf'
module RDFVocabularies
  class PCDMTerms < RDF::Vocabulary("http://pcdm.org/models#")

    # TODO switch to using generated vocabulary when ready; Then delete this file.


    # Class definitions
    term :AdministrativeSet
    term :Collection
    term :Object
    term :File

    # Property definitions
    property :hasMember
    property :hasFile
    property :hasRelatedFile
  end
end
