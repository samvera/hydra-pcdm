module Hydra::PCDM
  class ObjectIndexer < ActiveFedora::IndexingService
    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc["child_object_ids_ssim"] = object.child_object_ids
      end
    end

  end
end
