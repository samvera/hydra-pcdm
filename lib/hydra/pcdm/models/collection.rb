module Hydra
  module PCDM
    class Collection < ActiveFedora::Base
      configure :type => RDFVocabularies::PCDMTerms.Collection  # FIX: This is how ActiveTriples sets type, but doesn't work in ActiveFedora
      aggregates :members  # FIX: This causes error "Unknown constant Member" in collection_spec test.

      # behavior:
      #   1) PCDM::Collection can aggregate PCDM::Collection
      #   2) PCDM::Collection can aggregate PCDM::Object
      #   3) PCDM::Collection can NOT aggregate non-PCDM object
      #   4) PCDM::Collection can NOT contain PCDM::File
      #   5) PCDM::Collection can have descriptive metadata
      #   6) PCDM::Collection can have access metadata
      # TODO: add code to enforce behavior rules

      # TODO: Make members private so setting objects on aggregations has to go through the following methods.


      # def collections( collection )
      #   # check that collection is an instance of PCDM::Collection
      #   members << collection  if collection is_a? Hydra::PCDM::Collection
      # end
      #
      # def objects( object)
      #   # check that object is an instance of PCDM::Object
      #   members << object  if object is_a? Hydra::PCDM::Object
      # end

      # TODO: RDF metadata can be added using property definitions.
      #   * How to distinguish between descriptive and access metadata?
      #   * Are there any default properties to set for Collection's descriptive metadata?
      #   * Are there any default properties to set for Collection's access metadata?
      #   * Is there a way to override default properties defined in this class?

    end
  end
end

