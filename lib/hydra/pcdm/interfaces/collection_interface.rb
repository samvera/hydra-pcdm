module Hydra
  module PCDM
    module CollectionInterface
      type = RDFVocabularies::PCDMTerms.Collection
      aggregates :members

      # behavior:
      #   1) PCDM::Collection can aggregate PCDM::Collection
      #   2) PCDM::Collection can aggregate PCDM::Object
      #   3) PCDM::Collection can NOT contain PCDM::File
      # TODO: add code to enforce behavior rules



      # def collections( collection )
      #   # check that collection is an instance of PCDM::Collection
      #   self.members << collection  if collection is_a? Hydra::PCDM::Collection
      # end
      #
      # def objects( object)
      #   # check that object is an instance of PCDM::Object
      #   self.members << object  if object is_a? Hydra::PCDM::Object
      # end

    end
  end
end

