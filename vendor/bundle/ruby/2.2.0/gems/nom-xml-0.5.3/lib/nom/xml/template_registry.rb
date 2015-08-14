class Nom::XML::TemplateRegistry

  def initialize
    @templates = {}
  end

  # Define an XML template
  # @param [Symbol] a node_type key to associate with this template
  # @param [Block] a block that will receive a [Nokogiri::XML::Builder] object and any arbitrary parameters passed to +instantiate+
  # @return the +node_type+ Symbol
  def define(node_type, &block)
    unless node_type.is_a?(Symbol)
      raise TypeError, "Registered node type must be a Symbol (e.g., :person)"
    end
  
    @templates[node_type] = block
    node_type
  end

  # Undefine an XML template
  # @param [Symbol] the node_type key of the template to undefine
  # @return the +node_type+ Symbol
  def undefine(node_type)
    @templates.delete(node_type)
    node_type
  end

  # Check whether a particular node_type is defined
  # @param [Symbol] the node_type key to check
  # @return [True] or [False]
  def has_node_type?(node_type)
    @templates.has_key?(node_type)
  end

  # List defined node_types
  # @return [Array] of node_type symbols.
  def node_types
    @templates.keys
  end

  # Instantiate a detached, standalone node
  # @param [Symbol] the node_type to instantiate
  # @param additional arguments to pass to the template
  def instantiate(node_type, *args)
    result = create_detached_node(nil, node_type, *args)
    # Strip namespaces from text and CDATA nodes. Stupid Nokogiri.
      unless jruby?
        result.traverse { |node|
          if node.is_a?(Nokogiri::XML::CharacterData)
            node.namespace = nil
          end
        }
      end
    return result
  end

  ACTIONS = {
   :add_child => :self, :add_next_sibling => :parent, :add_previous_sibling => :parent, 
   :after => :parent, :before => :parent, :replace => :parent, :swap  => :parent
  }
  def method_missing(sym,*args,&block)
    method = sym.to_s.sub(/_+$/,'').to_sym
    if @templates.has_key?(method)
      instantiate(sym,*args)
    elsif ACTIONS.has_key?(method)
      target_node = args.shift
      attach_node(method, target_node, ACTIONS[method], *args, &block)
    elsif method.to_s =~ /^(#{ACTIONS.keys.join('|')})_(.+)$/
      method = $1.to_sym
      template = $2.to_sym
      if ACTIONS.has_key?(method) and @templates.has_key?(template)
        target_node = args.shift
        attach_node(method, target_node, ACTIONS[method], template, *args, &block)
      end
    else
      super(sym,*args)
    end

  end

  private
  
  def jruby?
    defined?(RUBY_ENGINE) and (RUBY_ENGINE == 'jruby')
  end

  # Create a new Nokogiri::XML::Node based on the template for +node_type+
  #
  # @param [Nokogiri::XML::Node] builder_node The node to use as starting point for building the node using Nokogiri::XML::Builder.with(builder_node).  This provides namespace info, etc for constructing the new Node object. If nil, defaults to {Nom::XML::TemplateRegistry#empty_root_node}.  This is just used to create the new node and will not be included in the response.
  # @param node_type a pointer to the template to use when creating the node
  # @param [Array] args any additional args
  def create_detached_node(builder_node, node_type, *args)
    proc = @templates[node_type]
    if proc.nil?
      raise NameError, "Unknown node type: #{node_type.to_s}"
    end
    if builder_node.nil?
      builder_node = empty_root_node
    end
    
    builder = Nokogiri::XML::Builder.with(builder_node) do |xml|
      proc.call(xml,*args)
    end
    builder_node.elements.last.remove
  end

  # Create a new XML node of type +node_type+ and attach it to +target_node+ using the specified +method+
  #
  # @param [Symbol] method name that should be called on +target_node+, usually a Nokogiri::XML::Node instance method
  # @param [Nokogiri::XML::Node or Nokogiri::XML::NodeSet with only one Node in it] target_node
  # @param [Symbol] builder_node_offset Indicates node to use as the starting point for _constructing_ the new node using {Nom::XML::TemplateRegistry#create_detached_node}. If this is set to :parent, target_node.parent will be used.  Otherwise, target_node will be used. 
  # @param node_type
  # @param [Array] args any additional arguments for creating the node
  def attach_node(method, target_node, builder_node_offset, node_type, *args, &block)
    if target_node.is_a?(Nokogiri::XML::NodeSet) and target_node.length == 1
      target_node = target_node.first
    end
    builder_node = builder_node_offset == :parent ? target_node.parent : target_node
    new_node = create_detached_node(builder_node, node_type, *args)
    result = target_node.send(method, new_node)
    # Strip namespaces from text and CDATA nodes. Stupid Nokogiri.
    unless jruby?
      new_node.traverse { |node|
        if node.is_a?(Nokogiri::XML::CharacterData)
          node.namespace = nil
        end
      }
    end
    if block_given?
      yield result
    else
      return result
    end
  end
  
  def empty_root_node
    Nokogiri::XML('<root/>').root
  end
  
end
