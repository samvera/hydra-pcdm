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
      type Vocab::PCDMTerms.Collection
      include ::Hydra::PCDM::PcdmBehavior
    end

    module ClassMethods
      def indexer
        Hydra::PCDM::CollectionIndexer
      end

      def type_validator
      end
    end

    def collections
      ordered_members.to_a.select(&:pcdm_collection?)
    end

    def collection_ids
      collections.map(&:id)
    end

    def pcdm_object?
      false
    end

    def pcdm_collection?
      true
    end

    def child_collections
      warn '[DEPRECATION] `child_collections` is deprecated in Hydra::PCDM.  Please use `collections` instead.  This has a target date for removal of 10-31-2015'
      collections
    end

    def child_collection_ids
      warn '[DEPRECATION] `child_collection_ids` is deprecated in Hydra::PCDM.  Please use `collection_ids` instead.  This has a target date for removal of 10-31-2015'
      collection_ids
    end
  end
end
