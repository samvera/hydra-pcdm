require 'active_fedora/aggregation'

module Hydra::PCDM
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

      def self.indexer
        Hydra::PCDM::Indexer
      end
    end


    # behavior:
    #   1) Hydra::PCDM::Object can aggregate (pcdm:hasMember) Hydra::PCDM::Object
    #   2) Hydra::PCDM::Object can aggregate (ore:aggregates) Hydra::PCDM::Object  (Object related to the Object)

    #   3) Hydra::PCDM::Object can contain (pcdm:hasFile) Hydra::PCDM::File
    #   4) Hydra::PCDM::Object can contain (pcdm:hasRelatedFile) Hydra::PCDM::File

    #   5) Hydra::PCDM::Object can NOT aggregate Hydra::PCDM::Collection
    #   6) Hydra::PCDM::Object can NOT aggregate non-PCDM object

    #   7) Hydra::PCDM::Object can have descriptive metadata
    #   8) Hydra::PCDM::Object can have access metadata


    def << arg

      # TODO: Not sure how to handle obj1.objects << new_object.  (see issue #45)
      #       Want to override << on obj1.objects to check that new_object passes Hydra::PCDM.object?

      raise ArgumentError, "argument must be either a pcdm object or a pcdm file" unless
          ( Hydra::PCDM.object? arg ) || ( Hydra::PCDM.file? arg )
      members << arg  if Hydra::PCDM.object? arg
      files   << arg  if Hydra::PCDM.file? arg
    end

    def objects= objects
      raise ArgumentError, "each object must be a pcdm object" unless objects.all? { |o| Hydra::PCDM.object? o }
      raise ArgumentError, "an object can't be an ancestor of itself" if object_ancestor?(objects)
      self.members = objects
    end

    def objects
      members.to_a.select { |m| Hydra::PCDM.object? m }
    end

    def object_ancestor? objects
      objects.each do |check|
        return true if check.id == self.id
        return true if ancestor?(check)
      end
      false
    end

    def ancestor? object
      return false if object.objects.empty?
      current_objects = object.objects
      next_batch = []
      while !current_objects.empty? do
        current_objects.each do |c|
          return true if c.id == self.id
          next_batch += c.objects
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

  end
end

