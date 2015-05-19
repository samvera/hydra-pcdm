module Hydra::PCDM
  class RemoveRelatedObjectFromCollection

    ##
    # Remove an object from a collection.
    #
    # @param [Hydra::PCDM::Collection] :parent_collection from which to remove the related object
    # @param [Hydra::PCDM::Object] :child_related_object being removed
    #
    # @return [Hydra::PCDM::Collection] the updated pcdm collection

    def self.call( parent_collection, child_related_object )
      raise ArgumentError, "parent_collection must be a pcdm collection" unless Hydra::PCDM.collection? parent_collection
      raise ArgumentError, "child_related_object must be a pcdm object" unless Hydra::PCDM.object? child_related_object


      # TODO FIX when related_objects is empty, related_objects.delete raises ActiveFedora::ObjectNotFoundError "Can't reload an object that hasn't been saved"  (activefedora-aggregation issue #805)

      # TODO related_objects.delete should...   (issue #103)(activefedora-aggregation issue #805)
      #   * return child_related_object when successful delete  (not Array [child_related_object])
      #   * return nil if child_related_object does not exist in parent_collection
      #   * raise error for any other problems

      # TODO Per issue #103, uncomment the following line when (activefedora issue #805) is resolved
      # parent_collection.related_objects.delete child_related_object

      # TODO Per issue #103, remove the following lines when (activefedora issue #805) is resolved
      return nil unless Hydra::PCDM::GetRelatedObjectsFromCollection.call( parent_collection ).include? child_related_object
      removed_related_object = parent_collection.related_objects.delete child_related_object
      removed_related_object = removed_related_object.first  if removed_related_object.is_a? Array
      removed_related_object
      # END WORK-AROUND
    end

  end
end
