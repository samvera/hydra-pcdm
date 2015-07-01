module Hydra::PCDM
  # PCDM::VersionedFile is just a PCDM::File with :versionable set to true
  # Q: Why is this in PCDM even though versioning is not part of the PCDM spec?
  # A: Because it's merely a stopgap for handling a deficiency in ActiveFedora::File
  #   which requires you to set :versionable on the class
  #   AF::File should be dynamically reading/writing and responding to the corresponding flag on the Fedora object.
  #   If PCDM::File changes, PCDM::VersionedFile must change too.
  class VersionedFile < Hydra::PCDM::File
    has_many_versions

    # This stuff wasn't inheriting from Hydra::PCDM::File, so repeating it here.
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
