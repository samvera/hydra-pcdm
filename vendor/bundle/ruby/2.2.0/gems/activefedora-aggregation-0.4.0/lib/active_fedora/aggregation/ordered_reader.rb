module ActiveFedora::Aggregation
  class OrderedReader
    include Enumerable
    attr_reader :root
    def initialize(root)
      @root = root
    end

    def each
      proxy = first_head
      while proxy
        yield proxy.target
        proxy = proxy.next
      end
    end

    private

    def first_head
      root.head
    end
  end
end
