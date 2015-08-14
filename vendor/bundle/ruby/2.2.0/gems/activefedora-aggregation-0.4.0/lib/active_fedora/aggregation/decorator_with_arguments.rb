module ActiveFedora::Aggregation
  # This is an Adapter to allow a Decorator to respond to the interface #new()
  # but still require other arguments to instantiate.
  class DecoratorWithArguments
    attr_reader :decorator, :args
    def initialize(decorator, *args)
      @decorator = decorator
      @args = args
    end

    def new(obj)
      decorator.new(obj, *args)
    end
  end
end
