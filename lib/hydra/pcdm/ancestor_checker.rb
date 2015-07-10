module Hydra::PCDM
  ##
  # Checks whether or not one object is an ancestor of another.
  class AncestorChecker
    attr_reader :record

    # @param [ActiveFedora::Base] record The object which may have ancestors.
    def initialize(record)
      @record = record
    end

    # @param [#members] potential_ancestor Object which may be the ancestor of
    #   the initialized record.
    def ancestor?(potential_ancestor)
      record == potential_ancestor || Hydra::PCDM::DeepMemberIterator.new(potential_ancestor).include?(record)
    end
  end
end
