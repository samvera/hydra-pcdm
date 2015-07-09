module Hydra::PCDM
  class DeepMemberIterator
    include Enumerable
    attr_reader :record
    def initialize(record)
      @record = HasMembers.new(record)
    end

    def each
      record.members.each do |member|
        yield member
      end
      record.members.each do |member|
        DeepMemberIterator.new(member).each do |deep_member|
          yield deep_member
        end
      end
    end
  end
  class HasMembers < SimpleDelegator
    def members
      __getobj__.try(:members) || []
    end
  end
end
