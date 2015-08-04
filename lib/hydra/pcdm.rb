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
      autoload :PcdmBehavior
    end

    autoload :CollectionIndexer
    autoload :ObjectIndexer

    # file services
    autoload :AddTypeToFile,                     'hydra/pcdm/services/file/add_type'
    autoload :GetMimeTypeForFile,                'hydra/pcdm/services/file/get_mime_type'

    # Iterators
    autoload :DeepMemberIterator,                'hydra/pcdm/deep_member_iterator'

    # Associations
    autoload :AncestorChecker,                   'hydra/pcdm/ancestor_checker'
    autoload :Validators,                        'hydra/pcdm/validators'

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
