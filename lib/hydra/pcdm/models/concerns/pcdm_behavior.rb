module Hydra::PCDM
  module PcdmBehavior
    extend ActiveSupport::Concern
    included do
      aggregates :members, predicate: RDFVocabularies::PCDMTerms.hasMember,
        class_name: "ActiveFedora::Base",
        type_validator: type_validator
      filters_association :members, as: :child_objects, condition: :pcdm_object?
      indirectly_contains :related_objects, has_member_relation: RDF::Vocab::ORE.aggregates,
        inserted_content_relation: RDF::Vocab::ORE.proxyFor, class_name: "ActiveFedora::Base",
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

    def parents
      aggregated_by
    end

    def parent_collections
      aggregated_by.select(&:pcdm_collection?)
    end

  end
end
