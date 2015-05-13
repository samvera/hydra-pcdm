module Hydra::PCDM
  class Indexer < ActiveFedora::IndexingService

    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc["objects_ssim"]     = object.objects.map { |o| o.id }
        solr_doc["collections_ssim"] = object.collections.map { |o| o.id } unless Hydra::PCDM.object?(object)
      end
    end

  end
end
