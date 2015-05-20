require 'spec_helper'

describe Hydra::PCDM::CollectionIndexer do
  let(:collection) { Hydra::PCDM::Collection.new }
  let(:child_collections1) { Hydra::PCDM::Collection.new(id: '123') }
  let(:child_collections2) { Hydra::PCDM::Collection.new(id: '456') }
  let(:object1) { Hydra::PCDM::Object.new(id: '789') }
  let(:indexer) { described_class.new(collection) }

  before do
    allow(collection).to receive(:child_collections).and_return([child_collections1, child_collections2])
    allow(collection).to receive(:objects).and_return([object1])
    allow(collection).to receive(:member_ids).and_return(['123', '456', '789'])
  end

  describe "#generate_solr_document" do
    subject { indexer.generate_solr_document }

    it "has fields" do
      expect(subject['child_collections_ssim']).to eq ['123', '456']
      expect(subject['objects_ssim']).to eq ['789']
      expect(subject['members_ssim']).to eq ['123', '456', '789']
    end
  end
end

