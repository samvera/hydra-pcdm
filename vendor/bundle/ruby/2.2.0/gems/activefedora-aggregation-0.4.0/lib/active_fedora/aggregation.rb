require 'active_fedora/aggregation/version'
require 'active_support'
require 'active-fedora'
require 'rdf/vocab'
require 'active_fedora/filter'

module ActiveFedora
  module Aggregation
    extend ActiveSupport::Autoload
    eager_autoload do
      autoload :Association
      autoload :AggregationExtension
      autoload :Proxy
      autoload :Builder
      autoload :Reflection
      autoload :BaseExtension
      autoload :LinkInserter
      autoload :OrderedReader
      autoload :PersistLinks
      autoload :OrderedProxy
      autoload :AppendsToAggregation
      autoload :ProxyOwner
      autoload :NullProxy
      autoload :DecoratingRepository
      autoload :DecoratorWithArguments
      autoload :DecoratorList
      autoload :ProxyRepository
    end

    ActiveFedora::Base.include BaseExtension
  end
end
