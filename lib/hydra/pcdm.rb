module Hydra::PCDM

  # vocabularies
  autoload :RDFVocabularies,        'hydra/pcdm/vocab/pcdm_terms'

  # models
  autoload :Collection,             'hydra/pcdm/models/collection'
  autoload :Object,                 'hydra/pcdm/models/object'
  autoload :File,                   'hydra/pcdm/models/file'

  # behavior concerns
  autoload :CollectionBehavior,     'hydra/pcdm/models/concerns/collection_behavior'
  autoload :ObjectBehavior,         'hydra/pcdm/models/concerns/object_behavior'

end
