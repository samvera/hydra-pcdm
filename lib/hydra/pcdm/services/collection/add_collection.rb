module Hydra::PCDM
  class AddCollectionToCollection

    ##
    # Add a collection to a collection.
    #
    # @param [Hydra::PCDM::Collection] :parent_collection to which to add collection
    # @param [Hydra::PCDM::Collection] :child_collection being added
    #
    # @return [Hydra::PCDM::Collection] the updated pcdm collection

    def self.call( parent_collection, child_collection )
      warn "[DEPRECATION] `Hydra::PCDM::AddCollectionToCollection` is deprecated.  Please use syntax `parent_collection.child_collections = child_collection` instead.  This has a target date for removal of 07-31-2015"
      parent_collection.child_collections << child_collection
    end

  end
end
