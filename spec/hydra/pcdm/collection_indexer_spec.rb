require 'spec_helper'

describe Hydra::PCDM::CollectionIndexer do
  let(:collection)         { Hydra::PCDM::Collection.new }
  let(:child_collection_ids) { ['123', '456'] }
  let(:child_object_ids) { ['789'] }
  let(:member_ids) { ['123', '456', '789'] }
  let(:indexer)            { described_class.new(collection) }

  before do
    allow(collection).to receive(:child_collection_ids).and_return(child_collection_ids)
    allow(collection).to receive(:child_object_ids).and_return(child_object_ids)
    allow(collection).to receive(:member_ids).and_return(member_ids)
  end

  describe "#generate_solr_document" do
    subject { indexer.generate_solr_document }

    it "has fields" do
      expect(subject['child_collection_ids_ssim']).to eq ['123', '456']
      expect(subject['child_object_ids_ssim']).to eq ['789']
      expect(subject['member_ids_ssim']).to eq ['123', '456', '789']
    end
  end
end

