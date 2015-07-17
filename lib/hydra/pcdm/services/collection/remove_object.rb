module Hydra::PCDM
  class RemoveObjectFromCollection

    ##
    # Remove an object from a collection.
    #
    # @param [Hydra::PCDM::Collection] :parent_collection from which to remove object
    # @param [Hydra::PCDM::Object] :child_object being removed
    # @param [Fixnum] :nth_occurrence remove nth occurrence of this object in the list (default=1)
    #
    # @return [Hydra::PCDM::Collection] the updated pcdm collection

    def self.call( parent_collection, child_object, nth_occurrence=1 )
      warn "[DEPRECATION] `Hydra::PCDM::RemoveCollectionFromCollection` is deprecated.  Please use syntax `parent_collection.child_collections.delete child_collection` instead which returns [child_collection] instead of child_collection.  This has a target date for removal of 07-31-2015"
      result = parent_collection.child_objects.delete child_object
      result = result.first if result.kind_of?(Array) && result.size >= 1      # temporarily done for compatibility with current service object API
      result

      # TODO FIX when members is empty, members.delete raises ActiveFedora::ObjectNotFoundError "Can't reload an object that hasn't been saved"  (activefedora-aggregation issue #35)

      # TODO -- The same object may be in the list multiple times.  (issue #102)
      #   * How to remove nth occurrence?
      #   * Default to removing 1st occurrence from the beginning of the list.

    end

  end
end
