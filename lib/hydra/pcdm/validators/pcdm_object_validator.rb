module Hydra::PCDM::Validators
  class PCDMObjectValidator
    def self.validate!(_association, record)
      unless record.try(:pcdm_object?)
        fail ActiveFedora::AssociationTypeMismatch.new "#{record} is not a PCDM object."
      end
    end
  end
end
