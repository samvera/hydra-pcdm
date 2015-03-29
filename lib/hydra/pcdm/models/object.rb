module Hydra
  module PCDM
    class Object < ActiveFedora::Base
      configure :type => RDFVocabularies::PCDMTerms.Object  # FIX: This is how ActiveTriples sets type, but doesn't work in ActiveFedora
      aggregates :members  # FIX: This causes error "Unknown constant Member" in object_spec test.

      # behavior:
      #   1) PCDM::Object can NOT aggregate PCDM::Collection
      #   2) PCDM::Object can aggregate PCDM::Object
      #   3) PCDM::Object can contain PCDM::File
      #   4) PCDM::Object can NOT aggregate non-PCDM object
      #   5) PCDM::Object can have descriptive metadata
      #   6) PCDM::Object can have access metadata
      # TODO: add code to enforce behavior rules

      # TODO: Make members private so setting objects on aggregations has to go through the following methods.

      # def objects( object)
      #   # check that object is an instance of PCDM::Object
      #   members << object  if object is_a? Hydra::PCDM::Object
      # end

      # def files( file )
      #   # check that file is an instance of PCDM::File
      #   contains << file  if object is_a? Hydra::PCDM::File
      # end

      # TODO: RDF metadata can be added using property definitions.
      #   * How to distinguish between descriptive and access metadata?
      #   * Are there any default properties to set for Object's descriptive metadata?
      #   * Are there any default properties to set for Object's access metadata?
      #   * Is there a way to override default properties defined in this class?

    end
  end
end

