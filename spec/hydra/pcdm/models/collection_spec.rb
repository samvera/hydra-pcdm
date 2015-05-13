require 'spec_helper'

describe Hydra::PCDM::Collection do

  let(:collection1) { Hydra::PCDM::Collection.create }
  let(:collection2) { Hydra::PCDM::Collection.create }
  let(:collection3) { Hydra::PCDM::Collection.create }
  let(:collection4) { Hydra::PCDM::Collection.create }
  let(:collection5) { Hydra::PCDM::Collection.create }

  let(:object1) { Hydra::PCDM::Object.create }
  let(:object2) { Hydra::PCDM::Object.create }
  let(:object3) { Hydra::PCDM::Object.create }

  let(:non_PCDM_object) { "I'm not a PCDM object" }
  let(:af_base_object)  { ActiveFedora::Base.create }

  # TEST the following behaviors...
  #   1) Hydra::PCDM::Collection can aggregate (pcdm:hasMember)  Hydra::PCDM::Collection (no recursive loop, e.g., A -> B -> C -> A)
  #   2) Hydra::PCDM::Collection can aggregate (pcdm:hasMember)  Hydra::PCDM::Object
  #   3) Hydra::PCDM::Collection can aggregate (ore:aggregates) Hydra::PCDM::Object  (Object related to the Collection)

  #   4) Hydra::PCDM::Collection can NOT aggregate non-PCDM object
  #   5) Hydra::PCDM::Collection can NOT contain (pcdm:hasFile)  Hydra::PCDM::File

  #   6) Hydra::PCDM::Collection can have descriptive metadata
  #   7) Hydra::PCDM::Collection can have access metadata


  describe '#collections=' do
    it 'should aggregate collections' do
      collection1.collections = [collection2, collection3]
      collection1.save
      expect(collection1.collections).to eq [collection2, collection3]
    end

    it 'should aggregate collections in a sub-collection of a collection' do
      collection1.collections = [collection2]
      collection1.save
      collection2.collections = [collection3]
      collection2.save
      expect(collection1.collections).to eq [collection2]
      expect(collection2.collections).to eq [collection3]
    end

    context 'with unacceptable collections' do
      let(:error_message) { "each collection must be a pcdm collection" }

      it 'should NOT aggregate Hydra::PCDM::Objects in collections aggregation' do
        expect{ collection1.collections = [object1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate non-PCDM objects in collections aggregation' do
        expect{ collection1.collections = [non_PCDM_object] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate AF::Base objects in collections aggregation' do
        expect{ collection1.collections = [af_base_object] }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'with acceptable collections' do
      describe 'aggregates collections that implement Hydra::PCDM' do
        before do
          class Kollection < ActiveFedora::Base
            include Hydra::PCDM::CollectionBehavior
          end
        end
        after { Object.send(:remove_const, :Kollection) }
        let(:kollection1) { Kollection.create }
        before do
          collection1.collections = [kollection1]
          collection1.save
        end
        subject { collection1.collections }
        it { is_expected.to eq [kollection1]}
      end

      describe 'aggregates collections that extend Hydra::PCDM' do
        before do
          class Cullection < Hydra::PCDM::Collection
          end
        end
        after { Object.send(:remove_const, :Cullection) }
        let(:cullection1) { Cullection.create }
        before do
          collection1.collections = [cullection1]
          collection1.save
        end
        subject { collection1.collections }
        it { is_expected.to eq [cullection1]}
      end
    end

    describe "adding collections that are ancestors" do
      let(:error_message) { "a collection can't be an ancestor of itself" }

      context "when the source collection is the same" do
        it "raises an error" do
          expect{ collection1.collections = [collection1]}.to raise_error(ArgumentError, error_message)
        end
      end
      
      before do
        collection1.collections = [collection2]
        collection1.save
      end
      
      it "raises and error" do
        expect{ collection2.collections = [collection1]}.to raise_error(ArgumentError, error_message)
      end
      
      context "with more ancestors" do
        before do
          collection2.collections = [collection3]
          collection2.save
        end
        
        it "raises an error" do
          expect{ collection3.collections = [collection1]}.to raise_error(ArgumentError, error_message)
        end
        
        context "with a more complicated example" do     
          before do
            collection3.collections = [collection4, collection5]
            collection3.save
          end
          
          it "raises errors" do
            expect{ collection4.collections = [collection1]}.to raise_error(ArgumentError, error_message)
            expect{ collection4.collections = [collection2]}.to raise_error(ArgumentError, error_message)
          end   
        end
      end
    end
  end

  describe '#collections' do
    it 'should return empty array when no members' do
      collection1.save
      expect(collection1.collections).to eq []
    end

    it 'should return empty array when only objects are aggregated' do
      collection1.objects = [object1,object2]
      collection1.save
      expect(collection1.collections).to eq []
    end

    context 'with other collections' do
      before do
        collection1.collections = [collection2,collection3]
        collection1.objects = [object1,object2]
        collection1.save
      end
      it 'should only return collections' do
        expect(collection1.collections).to eq [collection2,collection3]
      end
      it 'should solrize member ids' do
        expect(collection1.to_solr["objects_ssim"]).to include(object1.id,object2.id)
        expect(collection1.to_solr["objects_ssim"]).not_to include(collection3.id,collection2.id)
        expect(collection1.to_solr["collections_ssim"]).to include(collection3.id,collection2.id)
        expect(collection1.to_solr["collections_ssim"]).not_to include(object1.id,object2.id)
      end
   end
  end


  describe '#objects=' do
    it 'should aggregate objects' do
      collection1.objects = [object1,object2]
      collection1.save
      expect(collection1.objects).to eq [object1,object2]
    end

    context "with unacceptable objects" do
      let(:error_message) { "each object must be a pcdm object" }
      it 'should NOT aggregate Hydra::PCDM::Collection in objects aggregation' do
        expect{ collection1.objects = [collection2] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate non-PCDM objects in collections aggregation' do
        expect{ collection1.objects = [non_PCDM_object] }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'with acceptable objects' do
      describe 'aggregates objects that implement Hydra::PCDM' do
        before do
          class Ahbject < ActiveFedora::Base
            include Hydra::PCDM::ObjectBehavior
          end
        end
        after { Object.send(:remove_const, :Ahbject) }
        let(:ahbject1) { Ahbject.create }
        before do
          collection1.objects = [ahbject1]
          collection1.save
        end
        subject { collection1.objects }
        it { is_expected.to eq [ahbject1]}
      end

      describe 'aggregates objects that extend Hydra::PCDM' do
        before do
          class Awbject < Hydra::PCDM::Object
          end
        end
        after { Object.send(:remove_const, :Awbject) }
        let(:awbject1) { Awbject.create }
        before do
          collection1.objects = [awbject1]
          collection1.save
        end
        subject { collection1.objects }
        it { is_expected.to eq [awbject1]}
      end
    end
  end

  describe '#objects' do
    it 'should return empty array when no members' do
      collection1.save
      expect(collection1.objects).to eq []
    end

    it 'should return empty array when only collections are aggregated' do
      collection1.collections = [collection2,collection3]
      collection1.save
      expect(collection1.objects).to eq []
    end

    it 'should only return objects' do
      collection1.collections = [collection2,collection3]
      collection1.objects = [object1,object2]
      collection1.save
      expect(collection1.objects).to eq [object1,object2]
    end
  end

  describe 'Related objects' do
    let(:object) { Hydra::PCDM::Object.create }
    let(:collection) { Hydra::PCDM::Collection.create }

    before do
      collection.related_objects = [object]
      collection.save
    end

    it 'persists' do
      expect(collection.reload.related_objects).to eq [object]
    end
  end

end
