module Nom::XML::Decorators::Terminology

  def self.extended node
    node.add_terminology_method_overrides!
  end

  def add_terminology_method_overrides!
    self.term_accessors.each do |k, term|
      if self.respond_to_without_terms? k and not term.options[:override]
        raise "Trying to redefine method #{k} on #{self.to_s}"
      end
    end.select { |k, term| term.options[:override] }.each do |method, term|
       define_term_method(method, self.term_accessors[method.to_sym])
    end
  end

  def method_missing method, *args, &block
    if self.term_accessors[method.to_sym]
      define_term_method(method, self.term_accessors[method.to_sym])

      self.send(method, *args, &block)
    else
      begin
        self.document.template_registry.send(method, self, *args, &block)
      rescue NameError
        super
      end
    end
  end

  alias_method :respond_to_without_terms?, :respond_to?

# As of ruby 2.0, respond_to includes an optional 2nd arg:
#   a boolean controlling whether private methods are targeted.
# We don't actually care for term accessors (none private).
  def respond_to? method, private = false
    super || self.term_accessors[method.to_sym]
  end

  ##
  # Get the terms associated with this node
  def terms
    @terms ||= self.ancestors.map { |p| p.term_accessors(self).map { |keys, values| values } }.flatten.compact.uniq
  end

  protected
  ##
  # Collection of salient terminology accessors for this node
  #
  # The root note or document node should have all the root terms
  def term_accessors matching_node =  nil
    terms = case
      when (self == self.document.root or self.is_a? Nokogiri::XML::Document)
        root_terms
      else
        child_terms
    end

    terms &&= terms.select { |key, term| term.nodes.include? matching_node } if matching_node

    terms
  end

  private
  ##
  # Root terms for the document
  def root_terms
    self.document.terminology.terms
  end

  ##
  # Terms that are immediate children of this node, or are globally applicable
  def child_terms
    h = {}

    # collect the sub-terms of the terms applicable to this node
    terms.each do |term|
      term.terms.each do |k1, v1|
        h[k1] = v1
      end
    end

    # and mix in any global terms of this node's ancestors
    self.ancestors.each do |a|
      a.term_accessors.each { |k,t| h[k] ||= t if t.options[:global] }
    end

    h
  end

  def define_term_method method, term
    (class << self; self; end).send(:define_method, method.to_sym) do |*local_args|
      lookup_term(self.term_accessors[method.to_sym], *local_args)
    end
  end

  def lookup_term term, *args
    options = args.extract_options!

    args += options.map { |key, value| %{#{key}="#{value.gsub(/"/, '\\\"') }"} }

    xpath = term.local_xpath

    xpath += "[#{args.join('][')}]" unless args.empty?

    result = case self
               when Nokogiri::XML::Document
                 self.document.root.xpath(xpath, self.document.terminology_namespaces)
               else
                 self.xpath(xpath, self.document.terminology_namespaces)
               end

    result.values_for_term(term)
  end
end
