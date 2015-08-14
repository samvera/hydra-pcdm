module RDF::TriX
  ##
  # TriX serializer.
  #
  # This class supports both [REXML][] and [Nokogiri][] for XML processing,
  # and will automatically select the most performant implementation
  # (Nokogiri) when it is available. If need be, you can explicitly
  # override the used implementation by passing in a `:library` option to
  # `Writer.new` or `Writer.open`.
  #
  # [REXML]:    http://www.germane-software.com/software/rexml/
  # [LibXML]:   http://libxml.rubyforge.org/rdoc/
  # [Nokogiri]: http://nokogiri.org/
  #
  # @example Loading TriX serialization support
  #   require 'rdf/trix'
  #
  # @example Obtaining a TriX writer class
  #   RDF::Writer.for(:trix)         #=> RDF::TriX::Writer
  #   RDF::Writer.for("etc/test.xml")
  #   RDF::Writer.for(:file_name      => "etc/test.xml")
  #   RDF::Writer.for(:file_extension => "xml")
  #   RDF::Writer.for(:content_type   => "application/trix")
  #
  # @example Instantiating a Nokogiri-based writer
  #   RDF::TriX::Writer.new(output, :library => :nokogiri)
  #
  # @example Instantiating a REXML-based writer
  #   RDF::TriX::Writer.new(output, :library => :rexml)
  #
  # @example Serializing RDF statements into a TriX file
  #   RDF::TriX::Writer.open("etc/test.xml") do |writer|
  #     graph.each_statement do |statement|
  #       writer << statement
  #     end
  #   end
  #
  # @example Serializing RDF statements into a TriX string
  #   RDF::TriX::Writer.buffer do |writer|
  #     graph.each_statement do |statement|
  #       writer << statement
  #     end
  #   end
  #
  # @see http://www.w3.org/2004/03/trix/
  class Writer < RDF::Writer
    format RDF::TriX::Format

    ##
    # Returns the XML implementation module for this writer instance.
    #
    # @return [Module]
    attr_reader :implementation

    ##
    # Returns the current named graph context, if any.
    #
    # @return [RDF::Resource]
    attr_reader :context

    ##
    # Initializes the TriX writer instance.
    #
    # @param  [IO, File] output
    # @param  [Hash{Symbol => Object}] options
    #   any additional options (see `RDF::Writer#initialize`)
    # @option options [Symbol]         :library  (:nokogiri or :rexml)
    # @option options [String, #to_s]  :encoding ('utf-8')
    # @option options [Integer]        :indent   (2)
    # @yield  [writer] `self`
    # @yieldparam  [RDF::Writer] writer
    # @yieldreturn [void] ignored
    def initialize(output = $stdout, options = {}, &block)
      @context = nil
      @nesting = 0

      @library = case options[:library]
        when nil
          # Use Nokogiri or LibXML when available, and REXML otherwise:
          begin
            require 'nokogiri'
            :nokogiri
          rescue LoadError => e
            begin
              require 'libxml'
              :rexml # FIXME: no LibXML support implemented yet
            rescue LoadError => e
              :rexml
            end
          end
        when :libxml then :rexml # FIXME
        when :nokogiri, :libxml, :rexml
          options[:library]
        else
          raise ArgumentError.new("expected :rexml, :libxml or :nokogiri, but got #{options[:library].inspect}")
      end

      require "rdf/trix/writer/#{@library}"
      @implementation = case @library
        when :nokogiri then Nokogiri
        when :libxml   then LibXML # TODO
        when :rexml    then REXML
      end
      self.extend(@implementation)

      @encoding = (options[:encoding] || 'utf-8').to_s
      initialize_xml(options)
      super
    end

    ##
    # Defines a named graph context.
    #
    # @param  [RDF::Resource] name
    # @yield  [writer]
    # @yieldparam [RDF::TriX::Writer] writer
    # @return [void]
    def graph(name = nil, &block)
      @nesting += 1
      @graph = create_graph(@context = name)
      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
      @graph = nil
      @nesting -= 1
    end

    ##
    # Returns `true` if we are currently in a `writer.graph { ... }` block.
    #
    # @return [Boolean]
    def nested?
      @nesting > 0
    end

    protected :nested?

    ##
    # Generates an XML comment.
    #
    # @param  [String, #to_s] text
    # @return [void]
    # @see    RDF::Writer#write_comment
    def write_comment(text)
      (@graph || @trix) << create_comment(text)
    end

    ##
    # @private
    # @see    RDF::Writer#write_graph
    # @since  0.2.0
    def write_graph(graph)
      @graph = create_graph(@context = graph.context)
      graph.each_triple { |*triple| write_triple(*triple) }
    end

    ##
    # Generates the TriX representation of an RDF statement.
    #
    # @param  [RDF::Statement] statement
    # @return [void]
    def write_statement(statement)
      unless nested? || statement.context.to_s == @context.to_s
        @graph = create_graph(@context = statement.context)
      end
      write_triple(*statement.to_triple)
    end

    ##
    # Generates the TriX representation of a triple.
    #
    # @param  [RDF::Resource] subject
    # @param  [RDF::URI]      predicate
    # @param  [RDF::Value]    object
    # @return [void]
    def write_triple(subject, predicate, object)
      @graph = create_graph unless @graph
      @graph << format_triple(subject, predicate, object)
    end

    ##
    # Returns the TriX representation of a triple.
    #
    # @param  [RDF::Resource]          subject
    # @param  [RDF::URI]               predicate
    # @param  [RDF::Value]             object
    # @param  [Hash{Symbol => Object}] options
    # @return [Element]
    def format_triple(subject, predicate, object, options = {})
      create_element(:triple) do |triple|
        triple << format_value(subject, options)
        triple << format_value(predicate, options)
        triple << format_value(object, options)
      end
    end

    ##
    # Returns the TriX representation of a blank node.
    #
    # @param  [RDF::Node]              value
    # @param  [Hash{Symbol => Object}] options
    # @return [Element]
    def format_node(value, options = {})
      create_element(:id, value.id.to_s)
    end

    ##
    # Returns the TriX representation of a URI reference.
    #
    # @param  [RDF::URI]               value
    # @param  [Hash{Symbol => Object}] options
    # @return [Element]
    def format_uri(value, options = {})
      create_element(:uri, value.to_s)
    end

    ##
    # Returns the TriX representation of a literal.
    #
    # @param  [RDF::Literal, String, #to_s] value
    # @param  [Hash{Symbol => Object}]      options
    # @return [Element]
    def format_literal(value, options = {})
      case
        when value.has_datatype?
          create_element(:typedLiteral, value.value.to_s, 'datatype' => value.datatype.to_s)
        when value.has_language?
          create_element(:plainLiteral, value.value.to_s, 'xml:lang' => value.language.to_s)
        else
          create_element(:plainLiteral, value.value.to_s)
      end
    end
  end # Writer
end # RDF::TriX
