require 'spec_helper'

describe Hydra::PCDM::CollectionIndexer do
  let(:collection) { Hydra::PCDM::Collection.new }
  let(:collection_ids) { %w(123 456) }
  let(:object_ids) { ['789'] }
  let(:member_ids) { %w(123 456 789) }
  let(:indexer) { described_class.new(collection) }

  before do
    allow(collection).to receive(:ordered_collection_ids).and_return(collection_ids)
    allow(collection).to receive(:object_ids).and_return(object_ids)
    allow(collection).to receive(:member_ids).and_return(member_ids)
  end

  describe '#generate_solr_document' do
    subject { indexer.generate_solr_document }

    it 'has fields' do
      expect(subject['collection_ids_ssim']).to eq %w(123 456)
      expect(subject['object_ids_ssim']).to eq ['789']
      expect(subject['member_ids_ssim']).to eq %w(123 456 789)
    end
  end
end
