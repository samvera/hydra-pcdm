module RDF::TriX
  class Reader < RDF::Reader
    ##
    # REXML implementation of the TriX reader.
    #
    # @see http://www.germane-software.com/software/rexml/
    module REXML
      OPTIONS = {}.freeze

      ##
      # Returns the name of the underlying XML library.
      #
      # @return [Symbol]
      def self.library
        :rexml
      end

      ##
      # Initializes the underlying XML library.
      #
      # @param  [Hash{Symbol => Object}] options
      # @return [void]
      def initialize_xml(options = {})
        require 'rexml/document' unless defined?(::REXML)
        @xml = ::REXML::Document.new(@input, :compress_whitespace => %w{uri})
      end

      ##
      # @private
      # @see RDF::Reader#each_graph
      def each_graph(&block)
        if block_given?
          @xml.elements.each('TriX/graph') do |graph_element|
            graph = RDF::Graph.new(read_context(graph_element))
            read_statements(graph_element) { |statement| graph << statement }
            block.call(graph)
          end
        end
        enum_graph
      end

      ##
      # @private
      # @see RDF::Reader#each_statement
      def each_statement(&block)
        if block_given?
          @xml.elements.each('TriX/graph') do |graph_element|
            read_statements(graph_element, &block)
          end
        end
        enum_statement
      end

    protected

      ##
      # @private
      def read_context(graph_element)
        name = graph_element.elements.select { |element| element.name.to_s == 'uri' }.first.text.strip rescue nil
        name ? RDF::URI.intern(name) : nil
      end

      ##
      # @private
      def read_statements(graph_element, &block)
        context = read_context(graph_element)
        graph_element.elements.each('triple') do |triple_element|
          triple = triple_element.elements.to_a[0..2]
          triple = triple.map { |element| parse_element(element.name, element.attributes, element.text) }
          triple << {:context => context} if context
          block.call(RDF::Statement.new(*triple))
        end
      end
    end # REXML
  end # Reader
end # RDF::TriX
