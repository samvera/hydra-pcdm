require 'rdf'

module RDF
  ##
  # A Merged graph.
  #
  # Implements a merged graph, containing statements from one or more source graphs. This is done through lazy evaluation of the sources, so that a copy of each source isn't required.
  #
  # This class can also be used to change the context (graph name) of triples from the name used in the source.
  #
  # @example Constructing a merge with arguments
  #   aggregate = RDF::AggregateRepo.new(repo1, repo2)
  #
  # @example Constructing an aggregate with closure
  #   aggregate = RDF::MergeGraph.new do
  #     source graph1, context1
  #     source graph2, context2
  #     name false
  #   end
  #
  # @see http://www.w3.org/TR/rdf11-mt/#dfn-merge
  class MergeGraph
    include RDF::Value
    include RDF::Countable
    include RDF::Enumerable
    include RDF::Queryable

    ##
    # The set of aggregated `queryable` instances included in this aggregate
    #
    # @return [Array<Array<(RDF::Queryable, RDF::Resource)>>]
    attr_reader :sources

    ##
    # Name of this graph, used for setting the context on returned `Statements`.
    #
    # @return [Array<RDF::URI, false>]
    attr_reader :context

    ##
    # Create a new aggregation instance.
    #
    # @overload initialize(queryable = [], options = {})
    #   @param [Hash{Symbol => Object}] options ({})
    #   @option options [RDF::Resource] :context
    #   @option options [RDF::Resource] :name alias for :context
    #   @yield merger
    #   @yieldparam [RDF::MergeGraph] self
    #   @yieldreturn [void] ignored
    def initialize(options = {}, &block)
      @sources = []
      @context = options[:context] || options[:name]

      if block_given?
        case block.arity
        when 1 then block.call(self)
        else instance_eval(&block)
        end
      end
    end


    ##
    # Returns `true` to indicate that this is a graph.
    #
    # @return [Boolean]
    def graph?
      true
    end

    ##
    # Returns `true` if this is a named graph.
    #
    # @return [Boolean]
    # @note The next release, graphs will not be named, this will return false
    def named?
      !unnamed?
    end

    ##
    # Returns `true` if this is a unnamed graph.
    #
    # @return [Boolean]
    # @note The next release, graphs will not be named, this will return true
    def unnamed?
      @context.nil?
    end

    ##
    # MergeGraph is writable if any source is writable. Updates go to the last writable source.
    #
    # @return [Boolean]
    def writable?
      sources.any? {|(source, ctx)| source.writable?}
    end

    ##
    # Add a queryable to the set of constituent queryable instances
    #
    # @param [RDF::Queryable] queryable
    # @param [RDF::Resource] context
    # @return [RDF::MergeGraph] self
    def source(queryable, context)
      @sources << [queryable, context]
      self
    end
    alias_method :add, :source

    ##
    # Set the context for statements in this graph
    #
    # @param [RDF::Resource, false] name
    # @return [RDF::MergeGraph] self
    def name(name)
      @context = name
      self
    end

    # Repository overrides

    ##
    # @private
    # @see RDF::Durable#durable?
    def durable?
      sources.all? {|(source, ctx)| source.durable?}
    end

    ##
    # @private
    # @see RDF::Countable#empty?
    def empty?
      count == 0
    end

    ##
    # @private
    # @see RDF::Countable#count
    def count
      each_statement.to_a.length
    end

    ##
    # @private
    # @see RDF::Enumerable#has_statement?
    def has_statement?(statement)
      sources.any? do |(source, ctx)|
        statement = statement.dup
        statement.context = ctx
        source.has_statement?(statement)
      end
    end

    ##
    # @see RDF::Enumerable#each_statement
    def each(&block)
      return enum_for(:each) unless block_given?

      # Add everything to a new graph for de-duplication
      tmp = RDF::Graph.new(@context, :data => RDF::Repository.new)
      sources.each do |(source, ctx)|
        tmp << RDF::Graph.new(ctx || nil, :data => source)
      end
      tmp.each(&block)
    end

    ##
    # @private
    # @see RDF::Enumerable#has_context?
    def has_context?(value)
      @context == value
    end

    ##
    # @private
    # @see RDF::Enumerable#each_context
    def each_context(&block)
      if block_given?
        block.call(context) if context
      end
      enum_context
    end


    ##
    # Iterate over each graph, in order, finding named graphs from the most recently added `source`.
    #
    # @see RDF::Enumerable#each_graph
    def each_graph(&block)
      if block_given?
        block.call(self)
      end
      enum_graph
    end

  protected

    ##
    # @private
    # @see RDF::Queryable#query_pattern
    def query_pattern(pattern, &block)
      pattern = pattern.dup
      sources.each do |(source, ctx)|
        pattern.context = ctx
        source.send(:query_pattern, pattern, &block)
      end
    end
  end
end
