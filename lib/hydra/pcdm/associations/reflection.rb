module Hydra::PCDM
  class Reflection < ActiveFedora::Aggregation::Reflection
    def association_class
      Association
    end
  end
end
