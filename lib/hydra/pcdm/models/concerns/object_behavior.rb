require 'active_fedora/aggregation'

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

      aggregates :members, predicate: RDFVocabularies::PCDMTerms.hasMember,
        class_name: "ActiveFedora::Base"

      indirectly_contains :related_objects, has_member_relation: RDF::Vocab::ORE.aggregates,
        inserted_content_relation: RDF::Vocab::ORE.proxyFor, class_name: "ActiveFedora::Base",
        through: 'ActiveFedora::Aggregation::Proxy', foreign_key: :target

      directly_contains :files, has_member_relation: RDFVocabularies::PCDMTerms.hasFile,
        class_name: "Hydra::PCDM::File"
    end

    module ClassMethods
      def indexer
        Hydra::PCDM::ObjectIndexer
      end

      # Overrides https://github.com/projecthydra-labs/activefedora-aggregation/blob/9a110a07f31e03d39566553d4c4bec88c4d5a177/lib/active_fedora/aggregation/base_extension.rb#L32 to customize the Association that's generated to add more validation to it.
      def create_reflection(macro, name, options, active_fedora)
        if macro == :aggregation
          Hydra::PCDM::Reflection.new(macro, name, options, active_fedora).tap do |reflection|
            add_reflection name, reflection
          end
        else
          super
        end
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

    def parents
      aggregated_by
    end

    def parent_objects
      aggregated_by.select { |parent| parent.class.included_modules.include?(Hydra::PCDM::ObjectBehavior) }
    end

    def parent_collections
      aggregated_by.select { |parent| parent.class.included_modules.include?(Hydra::PCDM::CollectionBehavior) }
    end

    include ChildObjects

    def object_ancestor? objects
      objects.each do |check|
        return true if ancestor?(check)
      end
      false
    end

    def ancestor? object
      return true if object == self
      return false if object.child_objects.empty?
      current_objects = object.child_objects
      next_batch = []
      while !current_objects.empty? do
        current_objects.each do |c|
          return true if c == self
          next_batch += c.child_objects
        end
        current_objects = next_batch
      end
      false
    end

    def contains= files
      # check that file is an instance of Hydra::PCDM::File
      raise ArgumentError, "each file must be a pcdm file" unless
          files.all? { |f| Hydra::PCDM.file? f }
      super(files)
    end

    # Returns directly contained files that have the requested RDF Type
    # @param [RDF::URI] uri for the desired Type
    # @example
    #   filter_files_by_type(::RDF::URI("http://pcdm.org/ExtractedText"))
    def filter_files_by_type uri
      self.files.reject do |file|
        !file.metadata_node.type.include?(uri)
      end
    end

    # Finds or Initializes directly contained file with the requested RDF Type
    # @param [RDF::URI] uri for the desired Type
    # @example
    #   file_of_type(::RDF::URI("http://pcdm.org/ExtractedText"))
    def file_of_type uri
      matching_files =  filter_files_by_type(uri)
      if  matching_files.empty?
        file = self.files.build
        Hydra::PCDM::AddTypeToFile.call(file, uri)
      else
        return matching_files.first
      end
    end

  end
end

