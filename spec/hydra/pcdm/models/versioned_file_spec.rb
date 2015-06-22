require 'spec_helper'

describe Hydra::PCDM::File do

  let(:file) { Hydra::PCDM::VersionedFile.new }
  let(:reloaded) { Hydra::PCDM::VersionedFile.new(file.uri) }

  it "has_many_versions" do
    expect(file.class).to be_versionable
  end

  describe "when saving" do
    before do
      file.content = 'stuff'
      file.save
    end
    subject { reloaded }
    it { is_expected.to be_persisted }
    it "sets the PCDMTerms.File RDF type" do
      expect(reloaded.metadata_node.query(predicate: RDF.type, object: RDFVocabularies::PCDMTerms.File).map(&:object)).to eq [RDFVocabularies::PCDMTerms.File]
    end
  end

  describe "#label" do
    before do
      file.content = 'stuff'
      file.label = 'foo'
    end
    it "saves a label" do
      expect(file.label).to eq ['foo']
      expect(file.save).to be true
      expect(reloaded.label).to eq ['foo']
    end
  end

  describe "technical metadata" do
    let(:date_created) { Date.parse "Fri, 08 May 2015 08:00:00 -0400 (EDT)" }
    let(:date_modified) { Date.parse "Sat, 09 May 2015 09:00:00 -0400 (EDT)" }
    let(:content) { "hello world" }
    let(:file) { Hydra::PCDM::File.new.tap { |ds| ds.content = content } }
    before do
      file.file_name = "picture.jpg"
      file.file_size = content.length.to_s
      file.date_created = date_created
      file.has_mime_type = "application/jpg"
      file.date_modified = date_modified
      file.byte_order = "little-endian"
    end
    it "saves technical metadata" do
      expect(file.save).to be true
      expect(reloaded.file_name).to eq ["picture.jpg"]
      expect(reloaded.file_size).to eq [content.length.to_s]
      expect(reloaded.has_mime_type).to eq ["application/jpg"]
      expect(reloaded.date_created).to eq [date_created]
      expect(reloaded.date_modified).to eq [date_modified]
      expect(reloaded.byte_order).to eq ["little-endian"]
    end
  end

end
