module Hydra::PCDM::Validators
  class PCDMObjectValidator
    def self.validate!(association, record)
      unless record.try(:pcdm_object?)
        raise ActiveFedora::AssociationTypeMismatch.new "#{record} is not a PCDM object."
      end
    end
  end
end
