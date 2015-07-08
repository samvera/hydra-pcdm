module Hydra::PCDM
  class Association < ActiveFedora::Aggregation::Association
    # Override raise_on_type_mismatch to check for PCDM-specific validations of
    # associated objects.
    # @see ActiveFedora::Associations::Association#raise_on_type_mismatch
    def raise_on_type_mismatch(val)
      raise_if_invalid(val)
      raise_if_ancestor(val)
      super
    end

    private

    def raise_if_invalid(val)
      unless object?(val)
        raise ActiveFedora::AssociationTypeMismatch.new "#{val} is not a PCDM object or collection."
      end
    end

    def raise_if_ancestor(val)
      if AncestorChecker.new(owner).ancestor?(val)
        raise ActiveFedora::AssociationTypeMismatch.new "#{val} is an ancestor and can't be set as a member"
      end
    end

    def object?(member)
      member.try(:pcdm_object?) || member.try(:pcdm_collection?)
    end
  end
end
