module Hydra::PCDM
  class RemoveRelatedObjectFromObject

    ##
    # Remove an object from an object.
    #
    # @param [Hydra::PCDM::Object] :parent_object from which to remove the related object
    # @param [Hydra::PCDM::Object] :child_related_object being removed
    #
    # @return [Hydra::PCDM::Collection] the updated pcdm collection

    def self.call( parent_object, child_related_object )
      raise ArgumentError, "parent_object must be a pcdm object" unless Hydra::PCDM.object? parent_object
      raise ArgumentError, "child_related_object must be a pcdm object" unless Hydra::PCDM.object? child_related_object

      result = parent_object.related_objects.delete child_related_object
      result = result.first if result.kind_of?(Array) && result.size >= 1      # temporarily done for compatibility with current service object API
      result

      # TODO FIX when related_objects is empty, related_objects.delete raises ActiveFedora::ObjectNotFoundError "Can't reload an object that hasn't been saved"  (activefedora-aggregation issue #805)

    end

  end
end
