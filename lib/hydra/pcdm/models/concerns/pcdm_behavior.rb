module Hydra::PCDM
  module PcdmBehavior
    extend ActiveSupport::Concern
    included do
      aggregates :members, predicate: Vocab::PCDMTerms.hasMember,
                           class_name: 'ActiveFedora::Base',
                           type_validator: type_validator
      indirectly_contains :related_objects, has_member_relation: RDF::Vocab::ORE.aggregates,
                                            inserted_content_relation: RDF::Vocab::ORE.proxyFor, class_name: 'ActiveFedora::Base',
                                            through: 'ActiveFedora::Aggregation::Proxy', foreign_key: :target,
                                            type_validator: Validators::PCDMObjectValidator
    end

    module ClassMethods
      def type_validator
        @type_validator ||= Validators::CompositeValidator.new(
          super,
          Validators::PCDMValidator,
          Validators::AncestorValidator
        )
      end
    end

    def member_of
      aggregated_by
    end

    def objects
      members.select(&:pcdm_object?)
    end

    def object_ids
      objects.map(&:id)
    end

    def parents
      warn '[DEPRECATION] `parents` is deprecated in Hydra::PCDM.  Please use `member_of` instead.  This has a target date for removal of 10-31-2015'
      member_of
    end

    def in_collections
      aggregated_by.select(&:pcdm_collection?)
    end

    def parent_collections
      warn '[DEPRECATION] `parent_collections` is deprecated in Hydra::PCDM.  Please use `in_collections` instead.  This has a target date for removal of 10-31-2015'
      in_collections
    end

    def in_collection_ids
      in_collections.map(&:id)
    end

    def parent_collection_ids
      warn '[DEPRECATION] `parent_collection_ids` is deprecated in Hydra::PCDM.  Please use `in_collection_ids` instead.  This has a target date for removal of 10-31-2015'
      in_collection_ids
    end

    def ancestor?(record)
      ancestor_checker.ancestor?(record)
    end

    def ancestor_checker
      @ancestor_checker ||= ::Hydra::PCDM::AncestorChecker.new(self)
    end

    def child_objects
      warn '[DEPRECATION] `child_objects` is deprecated in Hydra::PCDM.  Please use `objects` instead.  This has a target date for removal of 10-31-2015'
      objects
    end

    def child_objects=(new_objects)
      warn '[DEPRECATION] `child_objects=` is deprecated in Hydra::PCDM.  Please use `objects=` instead.  This has a target date for removal of 10-31-2015'
      self.objects = new_objects
    end

    def child_object_ids
      warn '[DEPRECATION] `child_object_ids` is deprecated in Hydra::PCDM.  Please use `object_ids` instead.  This has a target date for removal of 10-31-2015'
      object_ids
    end
  end
end
