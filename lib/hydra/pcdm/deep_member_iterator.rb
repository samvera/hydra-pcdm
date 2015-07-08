module Hydra::PCDM
  class DeepMemberIterator
    include Enumerable
    attr_reader :record
    def initialize(record)
      @record = record
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
end
