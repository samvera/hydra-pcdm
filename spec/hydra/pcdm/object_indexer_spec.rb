require 'spec_helper'

describe Hydra::PCDM::ObjectIndexer do
  let(:object)        { Hydra::PCDM::Object.new }
  let(:child_object1) { Hydra::PCDM::Object.new(id: '123') }
  let(:child_object2) { Hydra::PCDM::Object.new(id: '456') }
  let(:indexer)       { described_class.new(object) }

  before do
    allow(object).to receive(:child_objects).and_return([child_object1, child_object2])
  end

  describe "#generate_solr_document" do
    subject { indexer.generate_solr_document }

    it "has fields" do
      expect(subject['child_objects_ssim']).to eq ['123', '456']
    end
  end
end
