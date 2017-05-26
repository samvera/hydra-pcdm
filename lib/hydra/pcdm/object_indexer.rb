module Hydra::PCDM
  class ObjectIndexer < PCDMIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc[Config.indexing_member_of_collection_ids_key] = object.member_of_collection_ids
      end
    end
  end
end
