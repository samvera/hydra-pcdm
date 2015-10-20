module Hydra::PCDM
  class ObjectIndexer < ActiveFedora::IndexingService
    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc['member_ids_ssim'] ||= []
        solr_doc['member_ids_ssim'] += object.member_ids
        solr_doc['member_ids_ssim'].uniq!
        solr_doc['object_ids_ssim'] = object.ordered_object_ids
      end
    end
  end
end
