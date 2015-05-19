module Hydra::PCDM
  class GetRelatedObjectsFromCollection

    ##
    # Get related objects from a collection.
    #
    # @param [Hydra::PCDM::Collection] :parent_collection to which the child objects are related
    #
    # @return [Array<Hydra::PCDM::Collection>] all related objects

    def self.call( parent_collection )
      raise ArgumentError, "parent_collection must be a pcdm collection" unless Hydra::PCDM.collection? parent_collection
      parent_collection.related_objects.to_a
    end

  end
end
