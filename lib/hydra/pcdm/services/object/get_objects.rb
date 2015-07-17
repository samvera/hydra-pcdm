module Hydra::PCDM
  class GetObjectsFromObject

    ##
    # Get member objects from an object in order.
    #
    # @param [Hydra::PCDM::Object] :parent_object in which the child objects are members
    #
    # @return [Array<Hydra::PCDM::Object>] all member objects

    def self.call( parent_object )
      warn "[DEPRECATION] `Hydra::PCDM::GetObjectsFromObject` is deprecated.  Please use syntax `child_objects = parent_object.child_objects` instead.  This has a target date for removal of 07-31-2015"
      parent_object.child_objects.to_a
    end

  end
end
