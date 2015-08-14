module Nom::XML::Decorators
  module TemplateRegistry
    def template(node_type, *args)
      template_registry.instantiate(node_type, *args)
    end
  end
end
