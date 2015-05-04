require 'active_fedora/aggregation'

module Hydra::PCDM
  class Collection < ActiveFedora::Base
    type RDFVocabularies::PCDMTerms.Collection  # TODO switch to using generated vocabulary when ready
    aggregates :members, :predicate => RDFVocabularies::PCDMTerms.hasMember, :class_name => "ActiveFedora::Base"



    # behavior:
    #   1) Hydra::PCDM::Collection can aggregate (pcdm:hasMember)  Hydra::PCDM::Collection (no infinite loop, e.g., A -> B -> C -> A)
    #   2) Hydra::PCDM::Collection can aggregate (pcdm:hasMember)  Hydra::PCDM::Object
    #   3) Hydra::PCDM::Collection can aggregate (ore:aggregates) Hydra::PCDM::Object  (Object related to the Collection)

    #   4) Hydra::PCDM::Collection can NOT aggregate non-PCDM object
    #   5) Hydra::PCDM::Collection can NOT contain (pcdm:hasFile)  Hydra::PCDM::File

    #   6) Hydra::PCDM::Collection can have descriptive metadata
    #   7) Hydra::PCDM::Collection can have access metadata
    # TODO: add code to enforce behavior rules

    # TODO: Make members private adding to an aggregations has to go through the following methods.
    # TODO: FIX: All of the following methods for aggregations are effected by the error "uninitialized constant Member".




    def << arg
      # check that arg is an instance of Hydra::PCDM::Collection or Hydra::PCDM::Object
      raise ArgumentError, "argument must be either a Hydra::PCDM::Collection or Hydra::PCDM::Object" unless
          arg.is_a?( Hydra::PCDM::Collection ) || arg.is_a?( Hydra::PCDM::Object )
      members << arg
    end

    def collections= collections
      # check that each collection is an instance of Hydra::PCDM::Collection
      raise ArgumentError, "each collection must be a Hydra::PCDM::Collection" unless
          collections.all? { |c| c.is_a? Hydra::PCDM::Collection }
      members = collections
    end

    def collections
      # TODO: query fedora for collection id && hasMember && rdf_type == RDFVocabularies::PCDMTerms.Collection
    end

    # TODO: Not sure how to handle coll1.collections << new_collection.
    #       Want to override << on coll1.collections to check that new_collection is_a? Hydra::PCDM::Collection

    def objects= objects
      # check that object is an instance of Hydra::PCDM::Object
      raise ArgumentError, "each object must be a Hydra::PCDM::Object" unless
          objects.all? { |o| o.is_a? Hydra::PCDM::Object }
      members = objects
    end

    def objects
      # TODO: query fedora for collection id && hasMember && rdf_type == RDFVocabularies::PCDMTerms.Object
    end

    # TODO: Not sure how to handle coll1.objects << new_object.
    #       Want to override << on coll1.objects to check that new_object is_a? Hydra::PCDM::Object


    def contains
      # always raise an error because contains is not an allowed behavior
      raise NoMethodError, "undefined method `contains' for :Hydra::PCDM::Collection"
    end

    # TODO: RDF metadata can be added using property definitions.
    #   * How to distinguish between descriptive and access metadata?
    #   * Are there any default properties to set for Collection's descriptive metadata?
    #   * Are there any default properties to set for Collection's access metadata?
    #   * Is there a way to override default properties defined in this class?

  end
end

