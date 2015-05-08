require 'active_fedora/aggregation'

module Hydra::PCDM
  module CollectionBehavior
    extend ActiveSupport::Concern

    included do
      type RDFVocabularies::PCDMTerms.Collection

      aggregates :members, predicate: RDFVocabularies::PCDMTerms.hasMember,
        class_name: "ActiveFedora::Base"

      indirectly_contains :related_objects, has_member_relation: RDF::Vocab::ORE.aggregates,
        inserted_content_relation: RDF::Vocab::ORE.proxyFor, class_name: "ActiveFedora::Base",
        through: 'ActiveFedora::Aggregation::Proxy', foreign_key: :target

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
          ( Hydra::PCDM.collection? arg ) || ( Hydra::PCDM.object? arg )
      members << arg
    end

    def collections= collections
      raise ArgumentError, "each collection must be a Hydra::PCDM::Collection" unless collections.all? { |c| Hydra::PCDM.collection? c }
      self.members = self.objects + collections
    end

    def collections
      all_members = self.members.container.to_a
      all_members.select { |m| Hydra::PCDM.collection? m }
    end

    def objects= objects
      raise ArgumentError, "each object must be a Hydra::PCDM::Object" unless objects.all? { |o| Hydra::PCDM.object? o }
      self.members = self.collections + objects
    end

    def objects
      all_members = self.members.container.to_a
      all_members.select { |m| Hydra::PCDM.object? m }
    end

    # TODO: RDF metadata can be added using property definitions.
    #   * How to distinguish between descriptive and access metadata?
    #   * Are there any default properties to set for Collection's descriptive metadata?
    #   * Are there any default properties to set for Collection's access metadata?
    #   * Is there a way to override default properties defined in this class?

    # TODO: Add ORE.aggregates related Hydra::PCDM::Objects.

  end
end

