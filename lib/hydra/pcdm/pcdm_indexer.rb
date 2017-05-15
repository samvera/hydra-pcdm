module Hydra::PCDM
  class PCDMIndexer < ActiveFedora::IndexingService
    # @yield [Hash] calls the yielded block with the solr document
    # @return [Hash] the solr document
    def generate_solr_document
      super do |solr_doc|
        solr_doc[Config.indexing_member_ids_key] ||= []
        solr_doc[Config.indexing_member_ids_key] += object.member_ids
        solr_doc[Config.indexing_member_ids_key].uniq!
        solr_doc[Config.indexing_object_ids_key] = object.ordered_object_ids
        yield(solr_doc) if block_given?
      end
    end
  end
end
