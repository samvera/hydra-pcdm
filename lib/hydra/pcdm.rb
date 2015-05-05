module Hydra
  module PCDM

    # vocabularies
    autoload :RDFVocabularies,        'hydra/pcdm/vocab/pcdm_terms'

    # models
    autoload :Collection,             'hydra/pcdm/models/collection'
    autoload :Object,                 'hydra/pcdm/models/object'
    autoload :File,                   'hydra/pcdm/models/file'

  end
end
