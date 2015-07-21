module Hydra::PCDM
  class PCDMValidator
    def self.validate!(reflection, record)
      if !record.try(:pcdm_object?) && !record.try(:pcdm_collection?)
        raise ActiveFedora::AssociationTypeMismatch.new "#{record} is not a PCDM object."
      end
    end
  end
end
