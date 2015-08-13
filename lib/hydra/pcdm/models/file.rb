module Hydra::PCDM
  class File < ActiveFedora::File
    include ActiveFedora::WithMetadata

    metadata do
      configure type: RDFVocabularies::PCDMTerms.File
      property :label, predicate: ::RDF::RDFS.label

      property :file_name, predicate: EBUCoreVocabularies::EBUCoreTerms.filename
      property :file_size, predicate: EBUCoreVocabularies::EBUCoreTerms.fileSize
      property :date_created, predicate: EBUCoreVocabularies::EBUCoreTerms.dateCreated
      property :has_mime_type, predicate: EBUCoreVocabularies::EBUCoreTerms.hasMimeType
      property :date_modified, predicate: EBUCoreVocabularies::EBUCoreTerms.dateModified
      property :byte_order, predicate: SweetjplVocabularies::SweetjplTerms.byteOrder

      # This is a server-managed predicate which means Fedora does not let us change it.
      property :file_hash, predicate: RDF::Vocab::PREMIS.hasMessageDigest
    end
  end
end
