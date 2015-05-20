module Hydra::PCDM
  class GetCollectionsFromCollection

    ##
    # Get member collections from a collection in order.
    #
    # @param [Hydra::PCDM::Collection] :parent_collection in which the child collections are members
    #
    # @return [Array<Hydra::PCDM::Collection>] all member collections

    def self.call( parent_collection )
      raise ArgumentError, "parent_collection must be a pcdm collection" unless Hydra::PCDM.collection? parent_collection

      parent_collection.child_collections
    end

  end
end
