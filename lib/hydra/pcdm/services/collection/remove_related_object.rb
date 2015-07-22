module Hydra::PCDM
  class RemoveRelatedObjectFromCollection

    ##
    # Remove an object from a collection.
    #
    # @param [Hydra::PCDM::Collection] :parent_collection from which to remove the related object
    # @param [Hydra::PCDM::Object] :child_related_object being removed
    #
    # @return [Hydra::PCDM::Collection] the updated pcdm collection

    def self.call( parent_collection, child_related_object )
      raise ArgumentError, "parent_collection must be a pcdm collection" unless Hydra::PCDM.collection? parent_collection
      raise ArgumentError, "child_related_object must be a pcdm object" unless Hydra::PCDM.object? child_related_object
      warn "[DEPRECATION] `Hydra::PCDM::RemoveRelatedObjectFromCollection` is deprecated.  Please use syntax `parent_collection.related_objects.delete child_related_object` instead.  This has a target date for removal of 07-31-2015"

      result = parent_collection.related_objects.delete child_related_object
      result = result.first if result.kind_of?(Array) && result.size >= 1      # temporarily done for compatibility with current service object API
      result

      # TODO FIX when related_objects is empty, related_objects.delete raises ActiveFedora::ObjectNotFoundError "Can't reload an object that hasn't been saved"  (activefedora-aggregation issue #805)

    end

  end
end
