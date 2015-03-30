module Hydra::PCDM
  class File < ActiveFedora::File
    configure :type => RDFVocabularies::PCDMTerms.File  # FIX: This is how ActiveTriples sets type, but doesn't work in ActiveFedora

    # behavior:
    #   1) PCDM::File can NOT aggregate anything
    #   2) PCDM::File can NOT contain PCDM::File
    #   3) PCDM::File can have technical metadata about one uploaded binary file
    # TODO: add code to enforce behavior rules

    # TODO: The only expected additional behavior for PCDM::File beyond ActiveFedora::File is the expression
    #       of additional technical metadata

  end
end

