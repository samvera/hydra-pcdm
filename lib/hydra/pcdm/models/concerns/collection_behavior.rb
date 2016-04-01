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
        Validators::PCDMCollectionValidator
      end
    end

    def collections
      members.select(&:pcdm_collection?)
    end

    def collection_ids
      members.select(&:pcdm_collection?).map(&:id)
    end

    def ordered_collections
      ordered_members.to_a.select(&:pcdm_collection?)
    end

    def ordered_collection_ids
      ordered_collections.map(&:id)
    end

    def pcdm_object?
      false
    end

    def pcdm_collection?
      true
    end
  end
end
