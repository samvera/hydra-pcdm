module ActiveFedora::Aggregation
  ##
  # Decorates a proxy owner such that it knows how to delete a proxy from its
  # ordered list.
  class ProxyOwner < SimpleDelegator
    def is_a?(klass)
      __getobj__.is_a?(klass)
    end

    # @param [#next, #prev] proxy A Proxy link to delete.
    def delete_proxy!(proxy)
      if proxy == head || head.nil? # Head is nil if proxy is now deleted.
        self.head = proxy.next
      end
      if proxy == tail || tail.nil? # Head is nil if proxy is now deleted.
        self.tail = proxy.prev
      end
      [head, tail].uniq.compact.each(&:reload)
      if changed?
        save!
      end
    end
  end
end
