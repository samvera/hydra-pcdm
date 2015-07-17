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
      warn "[DEPRECATION] `Hydra::PCDM::AddObjectToCollection` is deprecated.  Please use syntax `parent_collection.child_objects = child_object` instead.  This has a target date for removal of 07-31-2015"
      parent_collection.child_objects << child_object
    end

  end
end
