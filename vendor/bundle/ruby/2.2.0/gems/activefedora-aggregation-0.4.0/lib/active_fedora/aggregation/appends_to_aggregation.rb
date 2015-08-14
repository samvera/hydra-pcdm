module ActiveFedora::Aggregation
  class AppendsToAggregation < SimpleDelegator
    attr_reader :parent_node
    # @param [#next, #prev] proxy The proxy to add behavior to.
    # @param [#head, #tail] parent_node The aggregation to append proxies to.
    def initialize(proxy, parent_node)
      @parent_node = parent_node
      super(proxy)
    end

    def is_a?(klass)
      __getobj__.is_a?(klass)
    end

    def save(*args)
      insert_link do
        super
      end
    end

    private

    def insert_link
      result = yield
      if result
        LinkInserter.new(parent_node, self).call
      end
      result
    end
  end
end
