require 'active_support'
require 'mime/types'
require 'active_fedora/aggregation'


module Hydra
  module PCDM
    extend ActiveSupport::Autoload

    # vocabularies
    autoload :RDFVocabularies,        'hydra/pcdm/vocab/pcdm_terms'
    autoload :EBUCoreVocabularies,    'hydra/pcdm/vocab/ebucore_terms'
    autoload :SweetjplVocabularies,   'hydra/pcdm/vocab/sweetjpl_terms'

    # models
    autoload_under 'models' do
      autoload :Collection
      autoload :Object
      autoload :File
    end

    # behavior concerns
    autoload_under 'models/concerns' do
      autoload :CollectionBehavior
      autoload :ObjectBehavior
      autoload :ChildObjects
      autoload :PcdmBehavior
    end

    autoload :CollectionIndexer
    autoload :ObjectIndexer

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

    # file services
    autoload :AddTypeToFile,                     'hydra/pcdm/services/file/add_type'
    autoload :GetMimeTypeForFile,                'hydra/pcdm/services/file/get_mime_type'


    # object services
    autoload :AddFileToObject,                   'hydra/pcdm/services/object/add_file'
    autoload :AddRelatedObjectToObject,          'hydra/pcdm/services/object/add_related_object'
    autoload :CreateObject,                      'hydra/pcdm/services/object/create'
    autoload :GetObjectsFromObject,              'hydra/pcdm/services/object/get_objects'
    autoload :GetRelatedObjectsFromObject,       'hydra/pcdm/services/object/get_related_objects'
    autoload :GetFilesFromObject,                'hydra/pcdm/services/object/get_collections'
    autoload :RemoveObjectFromObject,            'hydra/pcdm/services/object/remove_object'
    autoload :RemoveRelatedObjectFromObject,     'hydra/pcdm/services/object/remove_related_object'

    # Iterators
    autoload :DeepMemberIterator,                'hydra/pcdm/deep_member_iterator'

    # Associations
    autoload :AncestorReflection,                'hydra/pcdm/associations/ancestor_reflection'
    autoload :AncestorAssociation,               'hydra/pcdm/associations/ancestor_association'
    autoload :AncestorChecker,                   'hydra/pcdm/ancestor_checker'


    # model validations
    def self.collection? collection
      return false unless collection.respond_to? :type
      Array(collection.type).include? RDFVocabularies::PCDMTerms.Collection
    end

    def self.object? object
      return false unless object.respond_to? :type
      Array(object.type).include? RDFVocabularies::PCDMTerms.Object
    end

    def self.file? file
      return false unless file.respond_to? :metadata_node
      Array(file.metadata_node.type).include? RDFVocabularies::PCDMTerms.File
    end

  end
end
