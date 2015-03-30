module Hydra::PCDM
  class Object < ActiveFedora::Base
    configure :type => RDFVocabularies::PCDMTerms.Object  # FIX: This is how ActiveTriples sets type, but doesn't work in ActiveFedora
    aggregates :members  # FIX: This causes error "Unknown constant Member" in object_spec test.

    # behavior:
    #   1) Hydra::PCDM::Object can NOT aggregate Hydra::PCDM::Collection
    #   2) Hydra::PCDM::Object can aggregate Hydra::PCDM::Object
    #   3) Hydra::PCDM::Object can contain Hydra::PCDM::File
    #   4) Hydra::PCDM::Object can NOT aggregate non-PCDM object
    #   5) Hydra::PCDM::Object can have descriptive metadata
    #   6) Hydra::PCDM::Object can have access metadata
    # TODO: add code to enforce behavior rules

    # TODO: Make members private so adding to an aggregations has to go through the following methods.
    # TODO: FIX: All of the following methods for aggregations are effected by the error "uninitialized constant Member".

    def << arg
      # check that arg is an instance of Hydra::PCDM::Object or Hydra::PCDM::File
      raise ArgumentError, "argument must be either a Hydra::PCDM::Object or Hydra::PCDM::File" unless
          arg.is_a?( Hydra::PCDM::Object ) || arg.is_a?( Hydra::PCDM::File )
      members << arg  if arg.is_a? Hydra::PCDM::Object
      files   << arg  if arg.is_a? Hydra::PCDM::File
    end

    def objects= objects
      # check that object is an instance of Hydra::PCDM::Object
      raise ArgumentError, "each object must be a Hydra::PCDM::Object" unless
          objects.all? { |o| o is_a? Hydra::PCDM::Object }
      members = objects
    end

    def objects
      # TODO: query fedora for object id && hasMember && rdf_type == RDFVocabularies::PCDMTerms.Object
    end

    # TODO: Not sure how to handle obj1.objects << new_object.
    #       Want to override << on obj1.objects to check that new_object is_a? Hydra::PCDM::Object


    def contains= files
      # check that file is an instance of Hydra::PCDM::File
      raise ArgumentError, "each file must be a Hydra::PCDM::File" unless
          files.all? { |f| f is_a? Hydra::PCDM::File }
      super(files)
    end


    # TODO: RDF metadata can be added using property definitions.
    #   * How to distinguish between descriptive and access metadata?
    #   * Are there any default properties to set for Object's descriptive metadata?
    #   * Are there any default properties to set for Object's access metadata?
    #   * Is there a way to override default properties defined in this class?

  end
end

