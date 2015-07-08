module Hydra::PCDM::Validators
  class MembersNotAncestors < ActiveModel::Validator
    def validate(record)
      record.members.each do |member|
        if ancestor?(record, member)
          record.errors.add(:members, "has a member which is an ancestor: #{member}")
        end
      end
    end

    private

    def ancestor?(record, member)
      record == member || Hydra::PCDM::DeepMemberIterator.new(member).find{|x| x == record}
    end
  end
end
