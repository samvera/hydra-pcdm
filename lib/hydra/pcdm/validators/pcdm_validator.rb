module Hydra::PCDM::Validators
  class PCDMValidator
    def self.validate!(reflection, record)
      if !record.try(:pcdm_object?) && !record.try(:pcdm_collection?)
        raise ActiveFedora::AssociationTypeMismatch.new "#{record} is not a PCDM object or collection."
      end
    end
  end
end
