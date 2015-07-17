require 'active_fedora/aggregation'

module Hydra::PCDM

  # behavior:
  #   1) Hydra::PCDM::Collection can aggregate (pcdm:hasMember)  Hydra::PCDM::Collection (no infinite loop, e.g., A -> B -> C -> A)
  #   2) Hydra::PCDM::Collection can aggregate (pcdm:hasMember)  Hydra::PCDM::Object
  #   3) Hydra::PCDM::Collection can aggregate (ore:aggregates) Hydra::PCDM::Object  (Object related to the Collection)

  #   4) Hydra::PCDM::Collection can NOT aggregate non-PCDM object
  #   5) Hydra::PCDM::Collection can NOT contain (pcdm:hasFile)  Hydra::PCDM::File

  #   6) Hydra::PCDM::Collection can have descriptive metadata
  #   7) Hydra::PCDM::Collection can have access metadata
  #
  module CollectionBehavior
    extend ActiveSupport::Concern

    included do
      type RDFVocabularies::PCDMTerms.Collection

      aggregates :members, predicate: RDFVocabularies::PCDMTerms.hasMember,
        class_name: "ActiveFedora::Base"

      filters_association :members, as: :child_collections, condition: :pcdm_collection?
      filters_association :members, as: :child_objects, condition: :pcdm_object?

      indirectly_contains :related_objects, has_member_relation: RDF::Vocab::ORE.aggregates,
        inserted_content_relation: RDF::Vocab::ORE.proxyFor, class_name: "ActiveFedora::Base",
        through: 'ActiveFedora::Aggregation::Proxy', foreign_key: :target

    end

    module ClassMethods
      def indexer
        Hydra::PCDM::CollectionIndexer
      end

      # Overrides https://github.com/projecthydra-labs/activefedora-aggregation/blob/9a110a07f31e03d39566553d4c4bec88c4d5a177/lib/active_fedora/aggregation/base_extension.rb#L32 to customize the Association that's generated to add more validation to it.
      def create_reflection(macro, name, options, active_fedora)
        if macro == :aggregation
          Hydra::PCDM::AncestorReflection.new(macro, name, options, active_fedora).tap do |reflection|
            add_reflection name, reflection
          end
        else
          super
        end
      end
    end

    def pcdm_object?
      false
    end

    def pcdm_collection?
      true
    end

    def parents
      aggregated_by
    end

    def parent_collections
      aggregated_by.select { |parent| parent.class.included_modules.include?(Hydra::PCDM::CollectionBehavior) }
    end

    def child_collection_ids
      child_collections.map(&:id)
    end

    include ChildObjects

     def collection_ancestor? collections
      warn "[DEPRECATION] `collection_ancestor?` is deprecated.  Please use `AncestorChecker.new(parent_collection).ancestor?(child_collection)` for each collection instead.  This has a target date for removal of 07-31-2015"
      collections.each do |col|
        return true if AncestorChecker.new(self).ancestor?(col)
      end
      false
    end

    def ancestor? collection
      warn "[DEPRECATION] `collection_ancestor?` is deprecated.  Please use `AncestorChecker.new(parent_collection).ancestor?(child_collection)` instead.  This has a target date for removal of 07-31-2015"
      AncestorChecker.new(self).ancestor?(collection)
    end
  end
end

