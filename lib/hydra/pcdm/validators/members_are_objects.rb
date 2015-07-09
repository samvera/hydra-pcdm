module Hydra::PCDM
  module Validators
    class MembersAreObjects < ActiveModel::Validator
      def validate(record)
        record.members.each do |member|
          unless member_is_object?(member)
            record.errors.add(:members, "has a non-PCDM object #{member}")
          end
        end
      end

      private

      def member_is_object?(member)
        member.try(:pcdm_object?) || member.try(:pcdm_collection?)
      end
    end
  end
end
