module Hydra::PCDM
  class GetCollectionsFromCollection

    ##
    # Get member collections from a collection in order.
    #
    # @param [Hydra::PCDM::Collection] :parent_collection in which the child collections are members
    #
    # @return [Array<Hydra::PCDM::Collection>] all member collections

    def self.call( parent_collection )
      warn "[DEPRECATION] `Hydra::PCDM::GetCollectionsFromCollection` is deprecated.  Please use syntax `child_collections = parent_collection.child_collections` instead.  This has a target date for removal of 07-31-2015"
      parent_collection.child_collections.to_a
    end

  end
end
