module ActiveFedora::Aggregation
  class Reflection < ActiveFedora::Reflection::AssociationReflection
    def association_class
      Association
    end

    def klass
      @klass ||= begin
        klass = class_name.constantize
        klass.respond_to?(:uri_to_id) ? klass : ActiveFedora::Base
      rescue NameError => e
        # If the NameError is a result of the class having a
        # NameError (e.g. NoMethodError) within it then raise the error.
        raise e if Object.const_defined? class_name
        # Otherwise the NameError was a result of not being able to find the class
        ActiveFedora::Base
      end
    end

    def predicate
      @options[:predicate] || ::RDF::Vocab::ORE.aggregates
    end

    def collection?
      true
    end
  end
end
