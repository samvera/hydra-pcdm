module Nom::XML
  class Terminology < Term
    attr_reader :document

    def initialize document = nil, options = {}, *args, &block
      @terms = {}
      @options = options || {}
      @document = document
      in_edit_context do
        yield(self) if block_given?
      end
    end

    def namespaces
      options[:namespaces] || {}
    end

    def terminology
      self
    end

    def xpath
      nil
    end

    def full_name
      %Q{Terminology:#{self.object_id}}
    end
  end
end
