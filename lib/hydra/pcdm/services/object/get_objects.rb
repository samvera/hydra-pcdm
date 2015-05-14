module Hydra::PCDM
  class GetObjectsFromObject

    ##
    # Get member objects from an object in order.
    #
    # @param [Hydra::PCDM::Object] :parent_object in which the child objects are members
    #
    # @return [Array<Hydra::PCDM::Object>] all member objects

    def self.call( parent_object )
      raise ArgumentError, "parent_object must be a pcdm object" unless Hydra::PCDM.object? parent_object

      parent_object.objects
    end

  end
end
