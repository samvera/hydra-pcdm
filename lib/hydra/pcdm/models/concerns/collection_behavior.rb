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

      def self.indexer
        Hydra::PCDM::Indexer
      end
    end

    # TODO: Remove this method, see issue #98
    def << arg
      raise ArgumentError, "argument must be either a Hydra::PCDM::Collection or Hydra::PCDM::Object" unless
          ( Hydra::PCDM.collection? arg ) || ( Hydra::PCDM.object? arg )
      members << arg
    end

    def collections= collections
      raise ArgumentError, "each collection must be a pcdm collection" unless collections.all? { |c| Hydra::PCDM.collection? c }
      raise ArgumentError, "a collection can't be an ancestor of itself" if collection_ancestor?(collections)
      self.members = self.objects + collections
    end

    def collections
      members.to_a.select { |m| Hydra::PCDM.collection? m }
    end

    def objects= objects
      raise ArgumentError, "each object must be a pcdm object" unless objects.all? { |o| Hydra::PCDM.object? o }
      self.members = self.collections + objects
    end

    def objects
      members.to_a.select { |m| Hydra::PCDM.object? m }
    end

    def collection_ancestor? collections
      collections.each do |check|
        return true if check.id == self.id
        return true if ancestor?(check)
      end
      false
    end

    def ancestor? collection
      return true if collection.id == self.id
      return false if collection.collections.empty?
      current_collections = collection.collections
      next_batch = []
      while !current_collections.empty? do
        current_collections.each do |c|
          return true if c.id == self.id
          next_batch += c.collections
        end
        current_collections = next_batch
      end
      false
    end

  end
end

