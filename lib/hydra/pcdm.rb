module Hydra
  module PCDM

    # vocabularies
    autoload :RDFVocabularies,        'hydra/pcdm/vocab/pcdm_terms'

    # models
    autoload :Collection,             'hydra/pcdm/models/collection'
    autoload :Object,                 'hydra/pcdm/models/object'
    autoload :File,                   'hydra/pcdm/models/file'

    # behavior concerns
    autoload :CollectionBehavior,     'hydra/pcdm/models/concerns/collection_behavior'
    autoload :ObjectBehavior,         'hydra/pcdm/models/concerns/object_behavior'

    # collection services
    autoload :CreateCollection,           'hydra/pcdm/services/collection/create'



    def self.collection? collection
      return false unless collection.respond_to? :type
      collection.type.include? RDFVocabularies::PCDMTerms.Collection
    end

    def self.object? object
      return false unless object.respond_to? :type
      object.type.include? RDFVocabularies::PCDMTerms.Object
    end

    def self.file? file
      return false unless file.respond_to? :type
      file.type.include? RDFVocabularies::PCDMTerms.File
    end

  end
end
