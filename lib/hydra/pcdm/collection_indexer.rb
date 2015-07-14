module Hydra::PCDM
  class CollectionIndexer < ObjectIndexer

    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc["members_ssim"]           = object.member_ids
        solr_doc["child_collections_ssim"] = object.child_collections.map { |o| o.id }
      end
    end

  end
end
