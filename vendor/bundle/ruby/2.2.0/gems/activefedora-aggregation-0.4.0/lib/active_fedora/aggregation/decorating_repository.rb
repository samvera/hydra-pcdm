module ActiveFedora::Aggregation
  ##
  # Decorates the results of a repository with the given decorator.
  class DecoratingRepository < SimpleDelegator
    attr_reader :decorator
    # @param [#new] decorator A decorator.
    # @param [#find, #new] base_repository A repository to decorate.
    def initialize(decorator, base_repository)
      @decorator = decorator
      super(base_repository)
    end

    def find(id)
      decorate(super(id))
    end

    def new(*args)
      result = decorate(super(*args))
      yield result if block_given?
      result
    end

    private

    def decorate(obj)
      decorator.new(obj)
    end
  end
end
