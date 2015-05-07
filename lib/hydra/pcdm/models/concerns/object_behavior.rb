require 'active_fedora/aggregation'

module Hydra::PCDM
  module ObjectBehavior
    extend ActiveSupport::Concern

    included do
      type RDFVocabularies::PCDMTerms.Object  # TODO switch to using generated vocabulary when ready
      aggregates :members, predicate: RDFVocabularies::PCDMTerms.hasMember, class_name: "ActiveFedora::Base"
      directly_contains :files, has_member_relation: RDFVocabularies::PCDMTerms.hasFile, class_name: "Hydra::PCDM::File"
    end


    # behavior:

    #   1) Hydra::PCDM::Object can aggregate (pcdm:hasMember) Hydra::PCDM::Object

    #   2) Hydra::PCDM::Object can contain (pcdm:hasFile) Hydra::PCDM::File
    #   3) Hydra::PCDM::Object can contain (pcdm:hasRelatedFile) Hydra::PCDM::File

    #   4) Hydra::PCDM::Object can NOT aggregate Hydra::PCDM::Collection
    #   5) Hydra::PCDM::Object can NOT aggregate non-PCDM object

    #   6) Hydra::PCDM::Object can have descriptive metadata
    #   7) Hydra::PCDM::Object can have access metadata
    # TODO: add code to enforce behavior rules

    # TODO: Make members private so adding to an aggregations has to go through the following methods.



    def << arg

      # TODO This fails.  Tests using << operator are marked xit.

      # TODO: Not sure how to handle obj1.objects << new_object.
      #       Want to override << on obj1.objects to check that new_object is_a? Hydra::PCDM::Object

      # check that arg is an instance of Hydra::PCDM::Object or Hydra::PCDM::File
      raise ArgumentError, "argument must be either a Hydra::PCDM::Object or Hydra::PCDM::File" unless
          ( Hydra::PCDM.object? arg ) || ( Hydra::PCDM.file? arg )
      members << arg  if Hydra::PCDM.object? arg
      files   << arg  if Hydra::PCDM.file? arg
    end

    def objects= objects
      raise ArgumentError, "each object must be a Hydra::PCDM::Object" unless objects.all? { |o| Hydra::PCDM.object? o }
      self.members = objects
    end

    def objects
      all_members = self.members.container.to_a
      all_members.select { |m| Hydra::PCDM.object? m }
    end

    def contains= files
      # check that file is an instance of Hydra::PCDM::File
      raise ArgumentError, "each file must be a Hydra::PCDM::File" unless
          files.all? { |f| Hydra::PCDM.file? f }
      super(files)
    end

    # TODO: Add hasRelatedFiles

    # TODO: RDF metadata can be added using property definitions.
    #   * How to distinguish between descriptive and access metadata?
    #   * Are there any default properties to set for Object's descriptive metadata?
    #   * Are there any default properties to set for Object's access metadata?
    #   * Is there a way to override default properties defined in this class?

  end
end

