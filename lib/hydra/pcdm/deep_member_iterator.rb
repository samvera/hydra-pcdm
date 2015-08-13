module Hydra::PCDM
  ##
  # Iterates over a record's members and all of their members in a breadth-first
  # search.
  class DeepMemberIterator
    include Enumerable
    attr_reader :record
    # @param [#members] record The object whose members are iterated across.
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
  ##
  # Small decorator to ensure that #members isn't undefined.
  class HasMembers < SimpleDelegator
    def members
      __getobj__.try(:members) || []
    end
  end
end
