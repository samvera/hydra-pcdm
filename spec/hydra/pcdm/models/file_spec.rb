require 'spec_helper'

describe Hydra::PCDM::File do

  let(:file) { Hydra::PCDM::File.new }
  let(:reloaded) { Hydra::PCDM::File.new(file.uri) }

  describe "when saving" do
    it "sets an RDF type" do
      file.content = 'stuff'
      expect(file.save).to be true
      expect(reloaded.metadata_node.query(predicate: RDF.type, object: RDFVocabularies::PCDMTerms.File).map(&:object)).to eq [RDFVocabularies::PCDMTerms.File]
    end
  end

  describe "#label" do
    it "saves a label" do
      file.content = 'stuff'
      file.label = 'foo'
      expect(file.label).to eq ['foo']
      expect(file.save).to be true
      expect(reloaded.label).to eq ['foo']
    end
  end
end
