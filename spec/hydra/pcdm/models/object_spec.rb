require 'spec_helper'

describe Hydra::PCDM::Object do

  let(:object1) { Hydra::PCDM::Object.new }
  let(:object2) { Hydra::PCDM::Object.new }
  let(:object3) { Hydra::PCDM::Object.new }

  describe '#objects=' do
    it 'should aggregate objects' do
      object1.objects = [object2, object3]
      object1.save
      expect(object1.objects).to eq [object2, object3]
    end
  end
  
  describe "validations" do
    context "when there are not PCDM objects in members" do
      it "should be invalid" do
        object = described_class.new
        object.members = [ActiveFedora::Base.new]
        expect(object).not_to be_valid
      end
      it "should validate with MembersAreObjects" do
        object = described_class.new
        expect(validators(object)).to include Hydra::PCDM::Validators::MembersAreObjects
      end
      it "should validate with MembersNotAncestors" do
        expect(validators(described_class.new)).to include Hydra::PCDM::Validators::MembersNotAncestors
      end

      def validators(object)
        object._validators.values.flatten.map(&:class)
      end
    end
  end

  context 'when aggregated by other objects' do

    before do
      # Using before(:all) and instance variable because regular :let syntax had a significant impact on performance
      # All of the tests in this context are describing idempotent behavior, so isolation between examples isn't necessary.
      @collection1 = Hydra::PCDM::Collection.new
      @collection2 = Hydra::PCDM::Collection.new
      @parent_object = Hydra::PCDM::Object.new
      @object =  Hydra::PCDM::Object.new
      @collection1.members << @object
      @collection2.members << @object
      @parent_object.members << @object
      allow(@object).to receive(:id).and_return("banana")
      proxies = [
        build_proxy(container: @collection1),
        build_proxy(container: @collection2),
        build_proxy(container: @parent_object)
      ]
      allow(ActiveFedora::Aggregation::Proxy).to receive(:where).with(proxyFor_ssim: @object.id).and_return(proxies)
    end

    describe 'parents' do
      subject { @object.parents }
      it "finds all nodes that aggregate the object with hasMember" do
        expect(subject).to include(@collection1, @collection2, @parent_object)
      end
    end

    describe 'parent_objects' do
      subject { @object.parent_objects }
      it "finds objects that aggregate the object with hasMember" do
        expect(subject).to eq [@parent_object]
      end
    end
    describe 'parent_collections' do
      subject { @object.parent_collections }
      it "finds collections that aggregate the object with hasMember" do
        expect(subject).to include(@collection1, @collection2)
        expect(subject.count).to eq 2
      end
    end
    def build_proxy(container:)
      instance_double(ActiveFedora::Aggregation::Proxy, container: container)
    end
  end

  describe 'Related objects' do
    before do
      object1.related_objects = [object2]
      object1.save
    end

    it 'persists' do
      expect(object1.reload.related_objects).to eq [object2]
    end
  end

  describe '#files' do
    subject { described_class.new }
    it "should have a files relation" do
      reflection = subject.reflections[:files]
      expect(reflection.macro).to eq :directly_contains
      expect(reflection.options[:has_member_relation]).to eq RDFVocabularies::PCDMTerms.hasFile
      expect(reflection.options[:class_name].to_s).to eq "Hydra::PCDM::File"
    end
  end

  describe "filtering files" do
    let(:object) { described_class.create }
    let(:thumbnail)   do
      file = object.files.build
      Hydra::PCDM::AddTypeToFile.call(file, pcdm_thumbnail_uri)
    end

    let(:file)                { object.files.build }
    let(:pcdm_thumbnail_uri)  { ::RDF::URI("http://pcdm.org/ThumbnailImage") }

    before do
      file
    end

    describe "filter_files_by_type" do
      context "when the object has files with that type" do
        before do
          thumbnail
        end
        it "allows you to filter the contained files by type URI" do
          expect( object.filter_files_by_type(pcdm_thumbnail_uri) ).to eq [thumbnail]
        end
        it "only overrides the #files method when you specify :type" do
          expect( object.files ).to eq [file, thumbnail]
        end
      end
      context "when the object does NOT have any files with that type" do
        it "returns an empty array" do
          expect( object.filter_files_by_type(pcdm_thumbnail_uri) ).to eq []
        end
      end
    end

    describe "file_of_type" do
      context "when the object has files with that type" do
        before do
          thumbnail
        end
        it "returns the first file with the requested type" do
          expect( object.file_of_type(pcdm_thumbnail_uri) ).to eq thumbnail
        end
      end
      context "when the object does NOT have any files with that type" do
        it "initializes a contained file with the requested type" do
          returned_file =  object.file_of_type(pcdm_thumbnail_uri)
          expect(object.files).to include(returned_file)
          expect(returned_file).to be_new_record
          expect(returned_file.metadata_node.get_values(:type)).to include(pcdm_thumbnail_uri)
        end
      end
    end
  end



  describe ".indexer" do
    after do
      Object.send(:remove_const, :Foo)
    end

    context "without overriding" do
      before do
        class Foo < ActiveFedora::Base
          include Hydra::PCDM::ObjectBehavior
        end
      end

      subject { Foo.indexer }
      it { is_expected.to eq Hydra::PCDM::ObjectIndexer }
    end

    context "when overridden with AS::Concern" do
      before do
        module IndexingStuff
          extend ActiveSupport::Concern

          class AltIndexer; end

          module ClassMethods
            def indexer
              AltIndexer
            end
          end
        end

        class Foo < ActiveFedora::Base
          include Hydra::PCDM::ObjectBehavior
          include IndexingStuff
        end
      end

      subject { Foo.indexer }
      it { is_expected.to eq IndexingStuff::AltIndexer }
    end
  end

end
