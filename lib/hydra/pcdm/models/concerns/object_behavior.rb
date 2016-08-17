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
      type Vocab::PCDMTerms.Object
      include ::Hydra::PCDM::PcdmBehavior

      directly_contains :files, has_member_relation: Vocab::PCDMTerms.hasFile,
                                class_name: 'Hydra::PCDM::File'

      indirectly_contains :member_of_collections,
                          has_member_relation: Vocab::PCDMTerms.memberOf,
                          inserted_content_relation: RDF::Vocab::ORE.proxyFor,
                          class_name: 'ActiveFedora::Base',
                          through: 'ActiveFedora::Aggregation::Proxy',
                          foreign_key: :target,
                          type_validator: Validators::PCDMCollectionValidator
    end

    module ClassMethods
      def indexer
        Hydra::PCDM::ObjectIndexer
      end

      def type_validator
        Validators::PCDMObjectValidator
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

    def in_objects
      member_of.select(&:pcdm_object?).to_a
    end

    def member_of_collection_ids
      member_of_collections.map(&:id)
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
      return matching_files.first unless matching_files.empty?
      Hydra::PCDM::AddTypeToFile.call(files.build, uri)
    end
  end
end
