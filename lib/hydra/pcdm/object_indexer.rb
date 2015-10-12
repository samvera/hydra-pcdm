module Hydra::PCDM
  class ObjectIndexer < ActiveFedora::IndexingService
    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc['object_ids_ssim'] = object.object_ids
      end
    end
  end
end
