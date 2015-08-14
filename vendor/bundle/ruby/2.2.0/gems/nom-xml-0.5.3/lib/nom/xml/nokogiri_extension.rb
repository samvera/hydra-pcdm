require 'active_support/core_ext/array'

module Nom::XML
  module NokogiriExtension

    ##
    # Apply NOM decorators to Nokogiri classes
    def nom!
      decorations = {
        Nokogiri::XML::Node => Nom::XML::Decorators::Terminology,
        Nokogiri::XML::Attr => Nom::XML::Decorators::Terminology,
        Nokogiri::XML::NodeSet => Nom::XML::Decorators::NodeSet,
        Nokogiri::XML::Document => Nom::XML::Decorators::TemplateRegistry
      }
      decorations.each_pair do |host, decorator|
        decorators(host) << decorator unless decorators(host).include? decorator
      end

      decorate!
      self
    end

    ##
    # Set the terminology accessors for this document
    def set_terminology options = {}, &block
      @terminology = Nom::XML::Terminology.new(self, options, &block)
      
      self
    end

    def terminology_namespaces
      @terminology.namespaces
    end

    def terminology
      @terminology ||= Nom::XML::Terminology.new self
    end

    def terminology= terminology
      @terminology = terminology
    end

    def template_registry
      @template_registry ||= Nom::XML::TemplateRegistry.new
    end

    # Define a new node template with the Nom::XML::TemplateRegistry.
    # * +name+ is a Symbol indicating the name of the new template.
    # * The +block+ does the work of creating the new node, and will receive
    #   a Nokogiri::XML::Builder and any other args passed to one of the node instantiation methods.
    def define_template name, &block
      self.template_registry.define name, &block
    end


  end
end
