module Hydra::PCDM
  class AddRelatedObjectToObject

    ##
    # Add a related object to an object.
    #
    # @param [Hydra::PCDM::Object] :parent_object to which to add the related object
    # @param [Hydra::PCDM::Object] :child_related_object being added
    #
    # @return [Hydra::PCDM::Object] the updated pcdm object

    def self.call( parent_object, child_related_object )
      raise ArgumentError, "parent_object must be a pcdm object" unless Hydra::PCDM.object? parent_object
      raise ArgumentError, "child_related_object must be a pcdm object" unless Hydra::PCDM.object? child_related_object
      warn "[DEPRECATION] `Hydra::PCDM::AddRelatedObjectToObject` is deprecated.  Please use syntax `parent_object.related_objects << child_related_object` instead.  This has a target date for removal of 07-31-2015"

      # parent_object.related_objects = parent_object.related_objects + child_related_object
      parent_object.related_objects << child_related_object
    end

  end
end
