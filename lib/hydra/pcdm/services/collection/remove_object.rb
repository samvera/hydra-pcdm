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
      raise ArgumentError, "parent_collection must be a pcdm collection" unless Hydra::PCDM.collection? parent_collection
      raise ArgumentError, "child_object must be a pcdm object" unless Hydra::PCDM.object? child_object


      # TODO FIX when members is empty, members.delete raises ActiveFedora::ObjectNotFoundError "Can't reload an object that hasn't been saved"  (activefedora-aggregation issue #35)

      # TODO members.delete should...   (issue #103)(activefedora-aggregation issue #34)
      #   * return child_object when successful delete  (not Array [child_object])
      #   * return nil if child_object does not exist in parent_collection
      #   * raise error for any other problems

      # TODO Per issue #103, uncomment the following line when (activefedora-aggregation issue #34) is resolved
      # parent_collection.members.delete child_object

      # TODO Per issue #103, remove the following lines when (activefedora-aggregation issue #34) is resolved
      return nil    unless parent_collection.members.include? child_object
      removed_object = parent_collection.members.delete child_object
      removed_object = removed_object.first  if removed_object.is_a? Array
      removed_object
      # END WORK-AROUND


      # TODO -- The same object may be in the list multiple times.  (issue #102)
      #   * How to remove nth occurrence?
      #   * Default to removing 1st occurrence from the beginning of the list.

    end

  end
end
