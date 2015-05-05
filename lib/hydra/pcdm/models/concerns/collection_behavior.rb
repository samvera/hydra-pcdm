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
    # TODO: add code to enforce behavior rules

    # TODO: Make members private adding to an aggregations has to go through the following methods.
    # TODO: FIX: All of the following methods for aggregations are effected by the error "uninitialized constant Member".

    def collections= members
      raise ArgumentError, "each collection must be a Hydra::PCDM::Collection" unless members.all? { |o| is_a_collection? o }
      self.members = members
    end

    def collections
      self.members
    end

    def objects= objects
      raise ArgumentError, "each object must be a Hydra::PCDM::Object" unless objects.all? { |o| is_a_object? o }
      self.members = objects
    end

    def objects
      self.members
    end

    def contains
      # always raise an error because contains is not an allowed behavior
      raise NoMethodError, "undefined method `contains' for :Hydra::PCDM::Collection"
    end

    def is_a_collection? collection
      return false unless collection.respond_to? :type
      collection.type.include? RDFVocabularies::PCDMTerms.Collection
    end

    def is_a_object? object
      return false unless object.respond_to? :type
      object.type.include? RDFVocabularies::PCDMTerms.Object
    end

    # TODO: RDF metadata can be added using property definitions.
    #   * How to distinguish between descriptive and access metadata?
    #   * Are there any default properties to set for Collection's descriptive metadata?
    #   * Are there any default properties to set for Collection's access metadata?
    #   * Is there a way to override default properties defined in this class?
  end

end
