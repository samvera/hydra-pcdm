module Hydra::PCDM
  class File < ActiveFedora::File
    include ActiveFedora::WithMetadata

    metadata do
      configure type: RDFVocabularies::PCDMTerms.File
      property :label, predicate: ::RDF::RDFS.label
    end

    # TODO move to ActiveFedora?
    def resource
      metadata_node
    end
  end
end
