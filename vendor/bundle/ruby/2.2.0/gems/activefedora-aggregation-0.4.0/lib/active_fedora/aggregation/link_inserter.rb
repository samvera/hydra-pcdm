module ActiveFedora::Aggregation
  class LinkInserter
    attr_reader :root, :proxy
    # @param [ProxyOwner] root the node representing the aggregation
    # @param [Proxy] proxy the proxy to add to the aggregation
    def initialize(root, proxy)
      @root = root
      @proxy = proxy
    end

    def call
      if root.head
        append
      else
        set
      end
      proxy.container = root
      persist_nodes!
    end

    private

    def append
      Appender.new(root, proxy).call
    end

    def set
      root.head = proxy
      root.tail = proxy
    end

    def persist_nodes!
      [proxy, proxy.prev].uniq.compact.each(&:save!)
    end

    class Appender
      attr_reader :root, :proxy
      def initialize(root, proxy)
        @root = root
        @proxy = proxy
      end

      def call
        last_proxy.next = proxy
        proxy.prev = last_proxy
        root.tail = proxy
      end

      private

      def last_proxy
        @last_proxy ||= root.tail
      end
    end
  end
end
