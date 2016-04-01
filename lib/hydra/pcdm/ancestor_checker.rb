module Hydra::PCDM
  ##
  # Checks whether or not one object is an ancestor of another.
  module AncestorChecker
    # @param options [Hash]
    # @option record [#pcdm_behavior?]
    # @option potential_ancestor [#pcdm_behavior?]
    # @return Boolean
    def self.call(options = {})
      record = options.fetch(:record)
      potential_ancestor = options.fetch(:potential_ancestor)
      return true if record == potential_ancestor
      Hydra::PCDM::DeepMemberIterator.new(potential_ancestor).include?(record)
    end
  end
end
