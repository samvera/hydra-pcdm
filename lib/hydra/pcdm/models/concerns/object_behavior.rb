module Hydra::PCDM
  # behavior:
  #   1) Hydra::PCDM::Object can aggregate (pcdm:hasMember) Hydra::PCDM::Object
  #   2) Hydra::PCDM::Object can aggregate (ore:aggregates) Hydra::PCDM::Object  (Object related to the Object)
  #   3) Hydra::PCDM::Object can contain (pcdm:hasFile) Hydra::PCDM::File
  #   4) Hydra::PCDM::Object can contain (pcdm:hasRelatedFile) Hydra::PCDM::File
  #   5) Hydra::PCDM::Object can NOT aggregate Hydra::PCDM::Collection
  #   6) Hydra::PCDM::Object can NOT aggregate non-PCDM object
  #   7) Hydra::PCDM::Object can have descriptive metadata
  #   8) Hydra::PCDM::Object can have access metadata
  module ObjectBehavior
    extend ActiveSupport::Concern

    included do
      type RDFVocabularies::PCDMTerms.Object
      include ::Hydra::PCDM::PcdmBehavior

      directly_contains :files, has_member_relation: RDFVocabularies::PCDMTerms.hasFile,
                                class_name: 'Hydra::PCDM::File'
    end

    module ClassMethods
      def indexer
        Hydra::PCDM::ObjectIndexer
      end

      def type_validator
        @type_validator ||= Validators::PCDMObjectValidator
      end
    end

    # @return [Boolean] whether this instance is a PCDM Object.
    def pcdm_object?
      true
    end

    # @return [Boolean] whether this instance is a PCDM Collection.
    def pcdm_collection?
      false
    end

    def parent_objects
      aggregated_by.select(&:pcdm_object?)
    end

    # Returns directly contained files that have the requested RDF Type
    # @param [RDF::URI] uri for the desired Type
    # @example
    #   filter_files_by_type(::RDF::URI("http://pcdm.org/ExtractedText"))
    def filter_files_by_type(uri)
      files.reject do |file|
        !file.metadata_node.type.include?(uri)
      end
    end

    # Finds or Initializes directly contained file with the requested RDF Type
    # @param [RDF::URI] uri for the desired Type
    # @example
    #   file_of_type(::RDF::URI("http://pcdm.org/ExtractedText"))
    def file_of_type(uri)
      matching_files = filter_files_by_type(uri)
      if matching_files.empty?
        file = files.build
        Hydra::PCDM::AddTypeToFile.call(file, uri)
      else
        return matching_files.first
      end
    end
  end
end
