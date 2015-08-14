module ActiveFedora::Aggregation
  ##
  # Repository for Proxies. This repository is responsible for decorating a
  # proxy such that it's useful for aggregation and is an attempt at
  # centralizing hard-coded dependencies without a dependency injection
  # container.
  class ProxyRepository < SimpleDelegator
    attr_reader :owner, :base_proxy_factory
    # @param [ActiveFedora::Base] owner The node which proxy will assert order
    #   on.
    # @param [#find, #new] base_proxy_factory The base factory which returns proxies
    #   that will be decorated.
    # @return [#find, #new] A repository which can return proxies useful for
    #  aggregation.
    def initialize(owner, base_proxy_factory)
      @owner = owner
      @base_proxy_factory = base_proxy_factory
      super(repository)
    end

    private

    def repository
      DecoratingRepository.new(proxy_decorator, base_proxy_factory)
    end

    def proxy_decorator
      DecoratorList.new(
        DecoratorWithArguments.new(OrderedProxy, proxy_owner),
        DecoratorWithArguments.new(AppendsToAggregation, proxy_owner)
      )
    end

    def proxy_owner
      @proxy_owner ||= ProxyOwner.new(owner)
    end
  end
end
