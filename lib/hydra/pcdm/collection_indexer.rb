module Hydra::PCDM
  class CollectionIndexer < PCDMIndexer
    # @yield [Hash] calls the yielded block with the solr document
    # @return [Hash] the solr document
    def generate_solr_document
      super do |solr_doc|
        solr_doc[Config.indexing_collection_ids_key] = object.ordered_collection_ids
        yield(solr_doc) if block_given?
      end
    end
  end
end
