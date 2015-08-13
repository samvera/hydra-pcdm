module Hydra::PCDM
  class Collection < ActiveFedora::Base
    include Hydra::PCDM::CollectionBehavior
  end
end
