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
      include ::Hydra::PCDM::PcdmBehavior

      filters_association :members, as: :child_collections, condition: :pcdm_collection?
    end

    module ClassMethods
      def indexer
        Hydra::PCDM::CollectionIndexer
      end
      
      def type_validator
      end
    end

    def pcdm_object?
      false
    end

    def pcdm_collection?
      true
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

