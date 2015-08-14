module ActiveFedora::Aggregation
  # A composite object to allow for a list of decorators to be treated like one.
  class DecoratorList
    attr_reader :decorators
    def initialize(*decorators)
      @decorators = decorators
    end

    def new(undecorated_object)
      decorators.inject(undecorated_object) do |obj, decorator|
        decorator.new(obj)
      end
    end
  end
end
