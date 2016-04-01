module Hydra::PCDM
  ##
  # Checks whether or not one object is an ancestor of another.
  module AncestorChecker
    # @param options [Hash]
    # @option record [#pcdm_behavior?]
    # @option potential_ancestor [#pcdm_behavior?]
    # @return Boolean
    def self.call(record, potential_ancestor)
      return true if record == potential_ancestor
      return false unless potential_ancestor.respond_to?(:members)
      return true if Array.wrap(potential_ancestor.members).detect { |member| call(record, member) }
      false
    end
  end
end
