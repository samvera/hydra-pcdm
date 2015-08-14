module ActiveFedora::Aggregation
  # A proxy which knows how to delete itself from an aggregation.
  class OrderedProxy < SimpleDelegator
    attr_reader :parent_node
    # @param [#next, #prev, #delete] proxy The proxy to add behavior to.
    # @param [#delete_proxy!] parent_node The aggregation to delete proxies
    #   from.
    def initialize(proxy, parent_node)
      @parent_node = parent_node
      super(proxy)
    end

    def is_a?(klass)
      __getobj__.is_a?(klass)
    end

    def delete(*args)
      link_node_if_true do
        super
      end
    end

    protected

    def link_node_if_true
      # Have to precache these or AF tries to access this node?
      next_or_null
      prev_or_null
      yield.tap do |result|
        if result
          # Have to reload proxies because otherwise you persist them with bad
          # referencing triples.
          [next_or_null, prev_or_null, parent_node].each(&:reload)
          prev_or_null.next = self.next
          next_or_null.prev = prev
          changed_nodes.each(&:save!)
          parent_node.delete_proxy!(self)
        end
      end
    end

    def next_or_null
      self.next || NullProxy.instance
    end

    def prev_or_null
      self.prev || NullProxy.instance
    end

    private

    def changed_nodes
      [self.prev, self.next].uniq.compact.select(&:changed?)
    end

  end
end
