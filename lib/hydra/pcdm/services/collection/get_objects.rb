module Hydra::PCDM
  class GetObjectsFromCollection

    ##
    # Get member objects from a collection in order.
    #
    # @param [Hydra::PCDM::Collection] :parent_collection in which the child objects are members
    #
    # @return [Array<Hydra::PCDM::Collection>] all member objects

    def self.call( parent_collection )
      warn "[DEPRECATION] `Hydra::PCDM::GetObjectsFromCollection` is deprecated.  Please use syntax `child_objects = parent_collection.child_objects` instead.  This has a target date for removal of 07-31-2015"
      parent_collection.child_objects.to_a
    end

  end
end
