module Hydra::PCDM
  module PcdmBehavior
    extend ActiveSupport::Concern
    included do
      aggregates :members, predicate: RDFVocabularies::PCDMTerms.hasMember,
        class_name: "ActiveFedora::Base"
      filters_association :members, as: :child_objects, condition: :pcdm_object?
      indirectly_contains :related_objects, has_member_relation: RDF::Vocab::ORE.aggregates,
        inserted_content_relation: RDF::Vocab::ORE.proxyFor, class_name: "ActiveFedora::Base",
        through: 'ActiveFedora::Aggregation::Proxy', foreign_key: :target
    end

    module ClassMethods
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

    def parents
      aggregated_by
    end

    def parent_collections
      aggregated_by.select { |parent| parent.class.included_modules.include?(Hydra::PCDM::CollectionBehavior) }
    end

  end
end
