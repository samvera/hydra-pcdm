require 'spec_helper'

describe Hydra::PCDM::ObjectIndexer do
  let(:object) { Hydra::PCDM::Object.new }
  let(:subobject1) { Hydra::PCDM::Object.new(id: '123') }
  let(:subobject2) { Hydra::PCDM::Object.new(id: '456') }
  let(:indexer) { described_class.new(object) }

  before do
    allow(object).to receive(:objects).and_return([subobject1, subobject2])
  end

  describe "#generate_solr_document" do
    subject { indexer.generate_solr_document }

    it "has fields" do
      expect(subject['objects_ssim']).to eq ['123', '456']
    end
  end
end
