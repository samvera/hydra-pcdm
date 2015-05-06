module Hydra::PCDM
  module CollectionBehavior
    extend ActiveSupport::Concern

    included do
      type RDFVocabularies::PCDMTerms.Collection  # TODO switch to using generated vocabulary when ready
      aggregates :members, :predicate => RDFVocabularies::PCDMTerms.hasMember, :class_name => "ActiveFedora::Base"
    end

    # behavior:
    #   1) Hydra::PCDM::Collection can aggregate (pcdm:hasMember)  Hydra::PCDM::Collection (no infinite loop, e.g., A -> B -> C -> A)
    #   2) Hydra::PCDM::Collection can aggregate (pcdm:hasMember)  Hydra::PCDM::Object
    #   3) Hydra::PCDM::Collection can aggregate (ore:aggregates) Hydra::PCDM::Object  (Object related to the Collection)

    #   4) Hydra::PCDM::Collection can NOT aggregate non-PCDM object
    #   5) Hydra::PCDM::Collection can NOT contain (pcdm:hasFile)  Hydra::PCDM::File

    #   6) Hydra::PCDM::Collection can have descriptive metadata
    #   7) Hydra::PCDM::Collection can have access metadata

    # TODO: Make members private adding to an aggregations has to go through the following methods.



    def << arg

      # TODO This fails.  Tests using << operator are marked xit.

      # TODO: Not sure how to handle coll1.collections << new_collection and coll1.objects << new_object.
      #       Want to override << on coll1.collections to check that new_collection is_a? Hydra::PCDM::Collection
      #       Want to override << on coll1.objects to check that new_object is_a? Hydra::PCDM::Object

      # check that arg is an instance of Hydra::PCDM::Collection or Hydra::PCDM::Object
      raise ArgumentError, "argument must be either a Hydra::PCDM::Collection or Hydra::PCDM::Object" unless
          arg.is_a?( Hydra::PCDM::Collection ) || arg.is_a?( Hydra::PCDM::Object )
      members << arg
    end

    def collections= collections
      # check that each collection is an instance of Hydra::PCDM::Collection
      raise ArgumentError, "each collection must be a Hydra::PCDM::Collection" unless
          collections.all? { |c| c.is_a? Hydra::PCDM::Collection }

      # TODO - how to prevent A - B - C - A causing a recursive loop of collections?

      current_objects = self.objects
      new_members = current_objects + collections
      self.members = new_members
    end

    def collections
      all_members = self.members.container.to_a
      all_members.select { |m| m.is_a? Hydra::PCDM::Collection }
    end

    def objects= objects
      # check that object is an instance of Hydra::PCDM::Object
      raise ArgumentError, "each object must be a Hydra::PCDM::Object" unless
          objects.all? { |o| o.is_a? Hydra::PCDM::Object }

      current_collections = self.collections
      new_members = current_collections + objects
      self.members = new_members
    end

    def objects
      all_members = self.members.container.to_a
      all_members.select { |m| m.is_a? Hydra::PCDM::Object }
    end

    def contains
      # always raise an error because contains is not an allowed behavior
      raise NoMethodError, "undefined method `contains' for :Hydra::PCDM::Collection"
    end

    # TODO: RDF metadata can be added using property definitions.
    #   * How to distinguish between descriptive and access metadata?
    #   * Are there any default properties to set for Collection's descriptive metadata?
    #   * Are there any default properties to set for Collection's access metadata?
    #   * Is there a way to override default properties defined in this class?

    # TODO: Add ORE.aggregates related Hydra::PCDM::Objects.

  end
end

