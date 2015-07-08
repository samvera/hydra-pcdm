require 'active_fedora/aggregation'

module Hydra::PCDM
  module CollectionBehavior
    extend ActiveSupport::Concern

    included do
      type RDFVocabularies::PCDMTerms.Collection

      aggregates :members, predicate: RDFVocabularies::PCDMTerms.hasMember,
        class_name: "ActiveFedora::Base"

      indirectly_contains :related_objects, has_member_relation: RDF::Vocab::ORE.aggregates,
        inserted_content_relation: RDF::Vocab::ORE.proxyFor, class_name: "ActiveFedora::Base",
        through: 'ActiveFedora::Aggregation::Proxy', foreign_key: :target
    end

    module ClassMethods
      def indexer
        Hydra::PCDM::CollectionIndexer
      end
    end

    # behavior:
    #   1) Hydra::PCDM::Collection can aggregate (pcdm:hasMember)  Hydra::PCDM::Collection (no infinite loop, e.g., A -> B -> C -> A)
    #   2) Hydra::PCDM::Collection can aggregate (pcdm:hasMember)  Hydra::PCDM::Object
    #   3) Hydra::PCDM::Collection can aggregate (ore:aggregates) Hydra::PCDM::Object  (Object related to the Collection)

    #   4) Hydra::PCDM::Collection can NOT aggregate non-PCDM object
    #   5) Hydra::PCDM::Collection can NOT contain (pcdm:hasFile)  Hydra::PCDM::File

    #   6) Hydra::PCDM::Collection can have descriptive metadata
    #   7) Hydra::PCDM::Collection can have access metadata

    def child_collections= collections
      raise ArgumentError, "each collection must be a pcdm collection" unless collections.all? { |c| Hydra::PCDM.collection? c }
      raise ArgumentError, "a collection can't be an ancestor of itself" if collection_ancestor?(collections)
      self.members = objects + collections
    end

    def child_collections
      members.to_a.select { |m| Hydra::PCDM.collection? m }
    end

    def objects= objects
      raise ArgumentError, "each object must be a pcdm object" unless objects.all? { |o| Hydra::PCDM.object? o }
      self.members = child_collections + objects
    end

    def objects
      members.to_a.select { |m| Hydra::PCDM.object? m }
    end

    def collection_ancestor? collections
      collections.each do |check|
        return true if ancestor?(check)
      end
      false
    end

    def ancestor? collection
      return true if collection == self
      return false if collection.child_collections.empty?
      current_collections = collection.child_collections
      next_batch = []
      while !current_collections.empty? do
        current_collections.each do |c|
          return true if c == self
          next_batch += c.child_collections
        end
        current_collections = next_batch
      end
      false
    end

  end
end

