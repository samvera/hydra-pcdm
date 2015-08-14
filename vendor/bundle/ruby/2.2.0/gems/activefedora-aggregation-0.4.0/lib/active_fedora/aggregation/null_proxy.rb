module ActiveFedora::Aggregation
  # A null proxy to simplify logic.
  class NullProxy
    include Singleton

    attr_writer :prev, :next
    def prev
      self
    end

    def next
      self
    end

    def reload
      self
    end

    def changed?
      false
    end
  end
end
