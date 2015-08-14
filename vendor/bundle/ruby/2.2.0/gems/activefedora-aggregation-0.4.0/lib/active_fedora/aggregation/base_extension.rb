module ActiveFedora::Aggregation
  module BaseExtension
    extend ActiveSupport::Concern

    # Queries the RDF graph to find all records that include this object in their aggregations
    # Since any class may be the target of an aggregation, this must be on every class extending
    # from ActiveFedora::Base
    # @return [Array] records that include this object in their aggregations
    def aggregated_by
      # In theory you should be able to find the aggregation predicate (ie ore:aggregates)
      # but Fedora does not return that predicate due to this bug in FCREPO:
      #   https://jira.duraspace.org/browse/FCREPO-1497
      # so we have to look up the proxies asserting RDF::Vocab::ORE.proxyFor
      # and return their containers.
      proxy_class.where(proxyFor_ssim: id).map(&:container)
    end

    private

      def proxy_class
        ActiveFedora::Aggregation::Proxy
      end

    module ClassMethods
      ##
      # Create an aggregation association on the class
      # @example
      #   class Image < ActiveFedora::Base
      #     aggregates :generic_files
      #   end
      def aggregates(name, options={})
        Builder.build(self, name, options)
      end

      ##
      # Create an association filter on the class
      # @example
      #   class Image < ActiveFedora::Base
      #     aggregates :generic_files
      #     filters_association :generic_files, as: :large_files, condition: :big_file?
      #   end
      def filters_association(extending_from, options={})
        name = options.delete(:as)
        ActiveFedora::Filter::Builder.build(self, name, options.merge(extending_from: extending_from))
      end

      def create_reflection(macro, name, options, active_fedora)
        case macro
        when :aggregation
          Reflection.new(macro, name, options, active_fedora).tap do |reflection|
            add_reflection name, reflection
          end
        when :filter
          ActiveFedora::Filter::Reflection.new(macro, name, options, active_fedora).tap do |reflection|
            add_reflection name, reflection
          end
        else
          super
        end
      end
    end
  end
end
