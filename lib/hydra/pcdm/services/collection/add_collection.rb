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
      raise ArgumentError, "parent_collection must be a pcdm collection" unless Hydra::PCDM.collection? parent_collection
      raise ArgumentError, "child_collection must be a pcdm collection" unless Hydra::PCDM.collection? child_collection
      raise ArgumentError, "a collection can't be an ancestor of itself" if parent_collection.ancestor? child_collection
      parent_collection.members << child_collection
    end

  end
end
