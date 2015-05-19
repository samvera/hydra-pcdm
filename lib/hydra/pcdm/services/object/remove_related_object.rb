module Hydra::PCDM
  class RemoveRelatedObjectFromObject

    ##
    # Remove an object from an object.
    #
    # @param [Hydra::PCDM::Object] :parent_object from which to remove the related object
    # @param [Hydra::PCDM::Object] :child_related_object being removed
    #
    # @return [Hydra::PCDM::Collection] the updated pcdm collection

    def self.call( parent_object, child_related_object )
      raise ArgumentError, "parent_object must be a pcdm object" unless Hydra::PCDM.object? parent_object
      raise ArgumentError, "child_related_object must be a pcdm object" unless Hydra::PCDM.object? child_related_object


      # TODO FIX when related_objects is empty, related_objects.delete raises ActiveFedora::ObjectNotFoundError "Can't reload an object that hasn't been saved"  (activefedora-aggregation issue #805)

      # TODO related_objects.delete should...   (issue #103)(activefedora-aggregation issue #805)
      #   * return child_related_object when successful delete  (not Array [child_related_object])
      #   * return nil if child_related_object does not exist in parent_object
      #   * raise error for any other problems

      # TODO Per issue #103, uncomment the following line when (activefedora issue #805) is resolved
      # parent_object.related_objects.delete child_related_object

      # TODO Per issue #103, remove the following lines when (activefedora issue #805) is resolved
      return nil unless Hydra::PCDM::GetRelatedObjectsFromObject.call( parent_object ).include? child_related_object
      removed_related_object = parent_object.related_objects.delete child_related_object
      removed_related_object = removed_related_object.first  if removed_related_object.is_a? Array
      removed_related_object
      # END WORK-AROUND
    end

  end
end
