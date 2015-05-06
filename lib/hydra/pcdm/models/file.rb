module Hydra::PCDM
  class File < ActiveFedora::File
    include ActiveFedora::WithMetadata

    metadata do
      configure type: RDFVocabularies::PCDMTerms.File
      property :label, predicate: ::RDF::RDFS.label
    end
  end
end
