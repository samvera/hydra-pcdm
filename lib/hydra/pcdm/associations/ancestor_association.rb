module Hydra::PCDM
  class AncestorAssociation < ActiveFedora::Aggregation::Association
  # class AncestorAssociation < ActiveFedora::Aggregation::FilterAssociation
    # Override raise_on_type_mismatch to check for PCDM-specific validations of aggregations.
    # @see ActiveFedora::Associations::Association#raise_on_type_mismatch
    def raise_on_type_mismatch(val)
      raise_if_ancestor(val)
      super
    end

    private

    def raise_if_ancestor(val)
      if AncestorChecker.new(owner).ancestor?(val)
        raise ArgumentError, "#{val.class} with ID: #{val.id} failed to pass AncestorChecker validation"
      end
    end
  end
end
