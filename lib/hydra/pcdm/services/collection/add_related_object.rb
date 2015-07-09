module Hydra::PCDM
  class AddRelatedObjectToCollection

    ##
    # Add a related object to a collection.
    #
    # @param [Hydra::PCDM::Collection] :parent_collection to which to add the related object
    # @param [Hydra::PCDM::Object] :child_related_object being added
    #
    # @return [Hydra::PCDM::Collection] the updated pcdm collection

    def self.call( parent_collection, child_related_object )
      raise ArgumentError, 'parent_collection must be a pcdm collection' unless Hydra::PCDM.collection? parent_collection
      raise ArgumentError, 'child_related_object must be a pcdm object' unless Hydra::PCDM.object? child_related_object

      # parent_collection.related_objects = parent_collection.related_objects.to_a + child_related_object
      parent_collection.related_objects << child_related_object
    end

  end
end
