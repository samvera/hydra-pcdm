module Nom::XML
  class Term
    attr_reader :name
    attr_reader :terms
    attr_reader :parent
    attr_writer :parent
    attr_reader :options

    PATH_SEPARATOR = '/'

    ##
    # Create a new Nom::XML::Term
    #
    # @attr [Nom::XML::Term] parent
    # @attr [String] name
    # @attr [Hash] options
    # @yield 
    def initialize parent, name, options = {}, *args, &block
      @name = name
      @terms = {}
      @parent = parent
      @options = options || {}

      in_edit_context do
        yield(self) if block_given?
      end
    end

    def full_name
      @full_name ||= [parent.full_name, "term:#{name}"].join(PATH_SEPARATOR)
    end

    ##
    # Traverse the tree to figure out what terminology this term belongs to
    # @return [Nom::XML::Terminology]
    def terminology
      @terminology ||= parent.terminology
    end

    ##
    # Get the absolute xpath to this node
    # @return [String]
    def xpath
      @xpath ||= [parent_xpath, local_xpath].flatten.compact.join(PATH_SEPARATOR)
    end

    ##
    # Get the relative xpath to this node from its immediate parent's term
    # @return [String]
    def local_xpath
      xpath = if xmlns.blank?
        ""
      else
        xmlns + ":"
      end
      xpath << "#{options[:path] || name}"
      xpath << "[#{options[:if]}]" if options[:if] and options[:if].is_a? String
      xpath << "[not(#{options[:unless]})]" if options[:unless] and options[:unless].is_a? String

      xpath
    end

    ##
    # Get the document nodes associated with this term
    # @return [Nokogiri::XML::NodeSet]
    def nodes
      terminology.document.root.xpath(xpath, terminology.namespaces)
    end

    ##
    # Get the document values associated with the term (after e.g. accessors)
    def values
      terminology.document.root.xpath(xpath, terminology.namespaces).values_for_term(self)
    end

    ##
    # Does this term have a sub-term called term_name
    # @attr [String] term_key
    # @return [Boolean]
    def key? term_key
      terms.key? term_key
    end

    ##
    # Flatten this term and all sub-terms (recursively)
    # @return [Array]
    def flatten
      [self, terms.map { |k,v| v.flatten }].flatten
    end

    def respond_to? method, *args, &block
      if in_edit_context?
        true
      elsif key? method
        true
      else
        super
      end
    end

    def method_missing method, *args, &block 
      if in_edit_context?
        add_term(method, *args, &block)
      elsif key?(method)
        term(method)
      else
        super
      end
    end

    def to_s
      %Q{#<#{self.class.to_s}:#{object_id} #{full_name} name="#{name}" xpath="#{xpath}">}
    end

    protected
    def in_edit_context &block
      @edit_context = true
      yield
      @edit_context = false
    end

    def in_edit_context?
      @edit_context
    end

    def add_term method, options = {}, *args, &block
      terms[method] = Term.new(self, method, options, *args, &block)
    end

    def term method, *args, &block
      terms[method]
    end

    ##
    # Get the XPath to the parent nodes for this term
    def parent_xpath
      @parent_xpath ||= self.parent.xpath
    end

    def xmlns
      (options[:xmlns] if options) || (self.parent.xmlns if self.parent)
    end

  end

end
