module Hydra
  module PCDM

    # vocabularies
    autoload :RDFVocabularies,        'hydra/pcdm/vocab/pcdm_terms'
    autoload :EBUCoreVocabularies,    'hydra/pcdm/vocab/ebucore_terms'
    autoload :SweetjplVocabularies,   'hydra/pcdm/vocab/sweetjpl_terms'

    # models
    autoload :Collection,             'hydra/pcdm/models/collection'
    autoload :Object,                 'hydra/pcdm/models/object'
    autoload :File,                   'hydra/pcdm/models/file'

    # behavior concerns
    autoload :CollectionBehavior,     'hydra/pcdm/models/concerns/collection_behavior'
    autoload :ObjectBehavior,         'hydra/pcdm/models/concerns/object_behavior'

    autoload :Indexer,                'hydra/pcdm/indexer'

    # collection services
    autoload :AddCollectionToCollection,         'hydra/pcdm/services/collection/add_collection'
    autoload :AddObjectToCollection,             'hydra/pcdm/services/collection/add_object'
    autoload :AddRelatedObjectToCollection,      'hydra/pcdm/services/collection/add_related_object'
    autoload :GetCollectionsFromCollection,      'hydra/pcdm/services/collection/get_collections'
    autoload :GetObjectsFromCollection,          'hydra/pcdm/services/collection/get_objects'
    autoload :GetRelatedObjectsFromCollection,   'hydra/pcdm/services/collection/get_related_objects'
    autoload :RemoveCollectionFromCollection,    'hydra/pcdm/services/collection/remove_collection'
    autoload :RemoveObjectFromCollection,        'hydra/pcdm/services/collection/remove_object'
    autoload :RemoveRelatedObjectFromCollection, 'hydra/pcdm/services/collection/remove_related_object'

    # object services
    autoload :AddFileToObject,                   'hydra/pcdm/services/object/add_file'
    autoload :AddObjectToObject,                 'hydra/pcdm/services/object/add_object'
    autoload :AddRelatedObjectToObject,          'hydra/pcdm/services/object/add_related_object'
    autoload :CreateObject,                      'hydra/pcdm/services/object/create'
    autoload :GetObjectsFromObject,              'hydra/pcdm/services/object/get_objects'
    autoload :GetRelatedObjectsFromObject,       'hydra/pcdm/services/object/get_related_objects'
    autoload :GetFilesFromObject,                'hydra/pcdm/services/object/get_collections'
    autoload :RemoveObjectFromObject,            'hydra/pcdm/services/object/remove_object'
    autoload :RemoveRelatedObjectFromObject,     'hydra/pcdm/services/object/remove_related_object'


    # model validations
    def self.collection? collection
      return false unless collection.respond_to? :type
      collection.type.include? RDFVocabularies::PCDMTerms.Collection
    end

    def self.object? object
      return false unless object.respond_to? :type
      object.type.include? RDFVocabularies::PCDMTerms.Object
    end

    def self.file? file
      return false unless file.respond_to? :metadata_node
      file.metadata_node.type.include? RDFVocabularies::PCDMTerms.File
    end

  end
end
