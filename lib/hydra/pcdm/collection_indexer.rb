module Hydra::PCDM
  class CollectionIndexer < ObjectIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc[Config.indexing_member_ids_key] ||= []
        solr_doc[Config.indexing_member_ids_key] += object.member_ids
        solr_doc[Config.indexing_member_ids_key].uniq!
        solr_doc[Config.indexing_collection_ids_key] = object.ordered_collection_ids
      end
    end
  end
end
