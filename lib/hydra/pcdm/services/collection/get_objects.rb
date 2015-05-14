module Hydra::PCDM
  class GetObjectsFromCollection

    ##
    # Get member objects from a collection in order.
    #
    # @param [Hydra::PCDM::Collection] :parent_collection in which the child objects are members
    #
    # @return [Array<Hydra::PCDM::Collection>] all member objects

    def self.call( parent_collection )
      raise ArgumentError, "parent_collection must be a pcdm collection" unless Hydra::PCDM.collection? parent_collection

      parent_collection.objects
    end

  end
end
