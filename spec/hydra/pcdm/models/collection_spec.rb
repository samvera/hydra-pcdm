require 'spec_helper'

describe Hydra::PCDM::Collection do

  let(:collection1) { Hydra::PCDM::Collection.create }
  let(:collection2) { Hydra::PCDM::Collection.create }
  let(:collection3) { Hydra::PCDM::Collection.create }

  let(:object1) { Hydra::PCDM::Object.create }
  let(:object2) { Hydra::PCDM::Object.create }

  describe '#child_collections=' do
    it 'should aggregate collections' do
      collection1.child_collections = [collection2, collection3]
      collection1.save
      expect(collection1.child_collections).to eq [collection2, collection3]
    end
  end

  describe "validations" do
    context "when there are not PCDM objects in members" do
      it "should validate with MembersAreObjects" do
        object = described_class.new
        expect(object._validators.values.flatten.map(&:class)).to include Hydra::PCDM::Validators::MembersAreObjects
      end
    end
  end

  describe '#objects=' do
    it 'should aggregate objects' do
      collection1.objects = [object1,object2]
      collection1.save
      expect(collection1.objects).to eq [object1,object2]
    end
  end

  describe 'Related objects' do
    let(:object1)     { Hydra::PCDM::Object.create }
    let(:collection1) { Hydra::PCDM::Collection.create }

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
