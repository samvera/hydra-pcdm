module Hydra::PCDM
  class Object < ActiveFedora::Base
    include Hydra::PCDM::ObjectBehavior
  end
end
