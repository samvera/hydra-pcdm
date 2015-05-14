module Hydra::PCDM
  class AddObjectToCollection

    ##
    # Add an object to a collection.
    #
    # @param [Hydra::PCDM::Collection] :parent_collection to which to add object
    # @param [Hydra::PCDM::Object] :child_object being added
    #
    # @return [Hydra::PCDM::Collection] the updated pcdm collection

    def self.call( parent_collection, child_object )
      raise ArgumentError, "parent_collection must be a pcdm collection" unless Hydra::PCDM.collection? parent_collection
      raise ArgumentError, "child_object must be a pcdm object" unless Hydra::PCDM.object? child_object
      parent_collection.members << child_object
    end

  end
end
