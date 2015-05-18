module Hydra::PCDM
  class RemoveCollectionFromCollection

    ##
    # Remove a collection from a collection.
    #
    # @param [Hydra::PCDM::Collection] :parent_collection from which to remove collection
    # @param [Hydra::PCDM::Collection] :child_collection being removed
    #
    # @return [Hydra::PCDM::Collection] the updated pcdm collection

    def self.call( parent_collection, child_collection )
      raise ArgumentError, "parent_collection must be a pcdm collection" unless Hydra::PCDM.collection? parent_collection
      raise ArgumentError, "child_collection must be a pcdm collection" unless Hydra::PCDM.collection? child_collection


      # TODO FIX when members is empty, members.delete raises ActiveFedora::ObjectNotFoundError "Can't reload an object that hasn't been saved"  (activefedora-aggregation issue #35)

      # TODO members.delete should...   (issue #103)(activefedora-aggregation issue #34)
      #   * return child_collection when successful delete  (not Array [child_collection])
      #   * return nil if child_collection does not exist in parent_collection
      #   * raise error for any other problems

      # TODO Per issue #103, uncomment the following line when (activefedora-aggregation issue #34) is resolved
      # parent_collection.members.delete child_collection

      # TODO Per issue #103, remove the following lines when (activefedora-aggregation issue #34) is resolved
      return nil unless Hydra::PCDM::GetCollectionsFromCollection.call( parent_collection ).include? child_collection
      removed_collection = parent_collection.members.delete child_collection
      removed_collection = removed_collection.first  if removed_collection.is_a? Array
      removed_collection
      # END WORK-AROUND
    end

  end
end
