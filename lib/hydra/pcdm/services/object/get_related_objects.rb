module Hydra::PCDM
  class GetRelatedObjectsFromObject

    ##
    # Get related objects from an object.
    #
    # @param [Hydra::PCDM::Object] :parent_object to which the child objects are related
    #
    # @return [Array<Hydra::PCDM::Object>] all related objects

    def self.call( parent_object )
      raise ArgumentError, "parent_object must be a pcdm object" unless Hydra::PCDM.object? parent_object
      warn "[DEPRECATION] `Hydra::PCDM::GetRelatedObjectsFromObject` is deprecated.  Please use syntax `related_objects = parent_object.related_objects` instead.  This has a target date for removal of 07-31-2015"
      parent_object.related_objects.to_a
    end

  end
end
