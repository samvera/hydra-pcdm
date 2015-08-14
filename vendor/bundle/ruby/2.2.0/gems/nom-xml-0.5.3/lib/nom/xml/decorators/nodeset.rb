module Nom::XML::Decorators::NodeSet

  def values_for_term term
      result = self
      result = result.select &(term.options[:if]) if term.options[:if].is_a? Proc
      result = result.reject &(term.options[:unless]) if term.options[:unless].is_a? Proc

      m = term.options[:accessor]
      return_value = case
        when m.nil?
          result
        when m.is_a?(Symbol)
           result.collect { |r| r.send(m) }.compact
        when m.is_a?(Proc)
          result.collect { |r| m.call(r) }.compact
        else
          raise "Unknown accessor class: #{m.class}"
        end

      if return_value and (term.options[:single] or (result.length == 1 and result.first.is_a? Nokogiri::XML::Attr))
        return return_value.first
      end

      return return_value
  end

  ##
  # Add a #method_missing handler to NodeSets. If all of the elements in the Nodeset
  # respond to a method (e.g. if it is a term accessor), call that method on all the
  # elements in the node
  def method_missing sym, *args, &block
    if self.all? { |node| node.respond_to? sym }
      result = self.collect { |node| node.send(sym, *args, &block) }.flatten
      self.class.new(self.document, result) rescue result
    else
      begin
        self.document.template_registry.send(sym, self, *args, &block)
      rescue NameError
        super
      end
    end
  end

    # ruby 2.0 sends two arguments to respond_to?
  def respond_to? sym, priv = false
      if self.all? { |node| node.respond_to? sym }
        true
      else
        super
      end
  end
end
