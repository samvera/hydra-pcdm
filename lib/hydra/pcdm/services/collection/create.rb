module Hydra::PCDM
  class CreateCollection

    ##
    # Create a pcdm collection.
    # @returns an instance of the new collection
    def self.call(  )
      Hydra::PCDM::Collection.create
    end

  end
end



