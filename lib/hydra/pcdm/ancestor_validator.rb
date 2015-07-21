module Hydra::PCDM
  class AncestorValidator
    def self.validate!(association,record)
      new(association.owner, record).validate!
    end

    attr_reader :owner, :record
    delegate :ancestor?, to: :ancestor_checker
    def initialize(owner, record)
      @owner = owner
      @record = record
    end

    def validate!
      if ancestor?(record)
        raise ArgumentError, "#{record.class} with ID: #{record.id} failed to pass AncestorChecker validation"
      end
    end

    private

    def ancestor_checker
      @ancestor_checker ||= AncestorChecker.new(owner)
    end
  end
end
