require 'hydra/pcdm/version'
require 'hydra/pcdm/vocab/pcdm_terms'
require 'active_fedora/aggregation'

module Hydra::PCDM

  # vocabularies
  autoload :PCDMTerms,              'hydra/pcdm/vocab/pcdm_terms'

  # models
  autoload :Collection,             'hydra/pcdm/models/collection'
  autoload :Object,                 'hydra/pcdm/models/object'
  autoload :File,                   'hydra/pcdm/models/file'


  def self.class_from_string(class_name, container_class=Kernel)
    container_class = container_class.name if container_class.is_a? Module
    container_parts = container_class.split('::')
    (container_parts + class_name.split('::')).flatten.inject(Kernel) do |mod, class_name|
      if mod == Kernel
        Object.const_get(class_name)
      elsif mod.const_defined? class_name.to_sym
        mod.const_get(class_name)
      else
        container_parts.pop
        class_from_string(class_name, container_parts.join('::'))
      end
    end
  end

end
