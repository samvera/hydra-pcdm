require 'active_fedora/aggregation'

module Hydra::PCDM
  class Collection < ActiveFedora::Base
    include Hydra::PCDM::CollectionBehavior
  end
end

