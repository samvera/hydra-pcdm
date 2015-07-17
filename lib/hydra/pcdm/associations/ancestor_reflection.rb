module Hydra::PCDM
  class AncestorReflection < ActiveFedora::Aggregation::Reflection
    def association_class
      AncestorAssociation
    end
  end
end
