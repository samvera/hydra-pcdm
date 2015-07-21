require 'spec_helper'

describe Hydra::PCDM::Collection do

  let(:collection1) { Hydra::PCDM::Collection.new }
  let(:collection2) { Hydra::PCDM::Collection.new }
  let(:collection3) { Hydra::PCDM::Collection.new }

  let(:object1) { Hydra::PCDM::Object.new }
  let(:object2) { Hydra::PCDM::Object.new }

  describe '#child_collections=' do
    it 'should aggregate collections' do
      collection1.child_collections = [collection2, collection3]
      expect(collection1.child_collections).to eq [collection2, collection3]
    end
  end

  describe '#child_objects=' do
    it 'should aggregate objects' do
      collection1.child_objects = [object1,object2]
      expect(collection1.child_objects).to eq [object1,object2]
    end
  end

  describe "#child_collection_ids" do
    let(:child1) { described_class.new(id: '1') }
    let(:child2) { described_class.new(id: '2') }
    let(:object) { described_class.new }
    before { object.child_collections = [child1, child2] }

    subject { object.child_collection_ids }

    it { is_expected.to eq ["1", "2"] }
  end


  context 'when aggregated by other objects' do

    before do
      # Using before(:all) and instance variable because regular :let syntax had a significant impact on performance
      # All of the tests in this context are describing idempotent behavior, so isolation between examples isn't necessary.
      @collection1 = Hydra::PCDM::Collection.new
      @collection2 = Hydra::PCDM::Collection.new
      @collection =  Hydra::PCDM::Collection.new
      @collection1.members << @collection
      @collection2.members << @collection
      allow(@collection).to receive(:id).and_return("banana")
      proxies = [
          build_proxy(container: @collection1),
          build_proxy(container: @collection2),
      ]
      allow(ActiveFedora::Aggregation::Proxy).to receive(:where).with(proxyFor_ssim: @collection.id).and_return(proxies)
    end

    describe 'parents' do
      subject { @collection.parents }
      it "finds all nodes that aggregate the object with hasMember" do
        expect(subject).to include(@collection1, @collection2)
        expect(subject.count).to eq 2
      end
    end

    describe 'parent_collections' do
      subject { @collection.parent_collections }
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
    let(:object1)     { Hydra::PCDM::Object.new }
    let(:collection1) { Hydra::PCDM::Collection.new }

    before do
      collection1.related_objects = [object1]
      collection1.save
    end

    it 'persists' do
      expect(collection1.reload.related_objects).to eq [object1]
    end
  end

  describe ".indexer" do
    after do
      Object.send(:remove_const, :Foo)
    end

    context "without overriding" do
      before do
        class Foo < ActiveFedora::Base
          include Hydra::PCDM::CollectionBehavior
        end
      end

      subject { Foo.indexer }
      it { is_expected.to eq Hydra::PCDM::CollectionIndexer }
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
          include Hydra::PCDM::CollectionBehavior
          include IndexingStuff
        end
      end

      subject { Foo.indexer }
      it { is_expected.to eq IndexingStuff::AltIndexer }
    end
  end
end
