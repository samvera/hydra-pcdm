require 'spec_helper'

describe Hydra::PCDM::Collection do

  let(:collection1) { Hydra::PCDM::Collection.create }
  let(:collection2) { Hydra::PCDM::Collection.create }
  let(:collection3) { Hydra::PCDM::Collection.create }
  let(:collection4) { Hydra::PCDM::Collection.create }

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


  # TODO need test to validate type is Hydra::PCDM::Collection
  # TODO need test for 3) Hydra::PCDM::Collection can aggregate (ore:aggregates) Hydra::PCDM::Object

  describe '#collections=' do
    it 'should aggregate collections' do
      collection1.collections = [collection2,collection3]
      collection1.save
      expect(collection1.collections).to eq [collection2,collection3]
    end

    xit 'should add a collection to the collections aggregation' do
      collection1.collections = [collection2,collection3]
      collection1.save
      collection1.collections << collection4
      expect(collection1.collections).to eq [collection2,collection3,collection4]
    end

    xit 'should aggregate collections in a sub-collection of a collection' do
      collection1.collections << collection2
      collection1.save
      collection2.collections << collection3
      expect(collection1.collections).to eq [collection2]
      expect(collection2.collections).to eq [collection3]
    end

    context 'with unacceptable collections' do
      it 'should NOT aggregate Hydra::PCDM::Objects in collections aggregation' do
        expect{ collection1.collections = [object1] }.to raise_error(ArgumentError,"each collection must be a Hydra::PCDM::Collection")
      end

      it 'should NOT aggregate non-PCDM objects in collections aggregation' do
        expect{ collection1.collections = [non_PCDM_object] }.to raise_error(ArgumentError,"each collection must be a Hydra::PCDM::Collection")
      end

      it 'should NOT aggregate AF::Base objects in collections aggregation' do
        expect{ collection1.collections = [af_base_object] }.to raise_error(ArgumentError,"each collection must be a Hydra::PCDM::Collection")
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

    xit 'should NOT allow infinite loop in chain of aggregated collections' do
       # TODO: write test to DISALLOW:  A -> B -> C -> A
       # see issue #50
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

    it 'should only return collections' do
      collection1.collections = [collection2,collection3]
      collection1.objects = [object1,object2]
      collection1.save
      expect(collection1.collections).to eq [collection2,collection3]
    end
  end


  describe '#objects=' do
    it 'should aggregate objects' do
      collection1.objects = [object1,object2]
      collection1.save
      expect(collection1.objects).to eq [object1,object2]
    end

    xit 'should add an object to the objects aggregation' do
      collection1.objects = [object1,object2]
      collection1.save
      collection1.objects << object3
      expect(collection1.objects).to eq [object1,object2,object3]
    end

    context "with unacceptable objects" do
      it 'should NOT aggregate Hydra::PCDM::Collection in objects aggregation' do
        expect{ collection1.objects = [collection2] }.to raise_error(ArgumentError,"each object must be a Hydra::PCDM::Object")
      end

      it 'should NOT aggregate non-PCDM objects in collections aggregation' do
        expect{ collection1.objects = [non_PCDM_object] }.to raise_error(ArgumentError,"each object must be a Hydra::PCDM::Object")
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

  describe '#METHOD_TO_SET_METADATA' do
    xit 'should be able to set descriptive metadata' do
      #   6) Hydra::PCDM::Collection can have descriptive metadata

      # TODO Write test

    end

    xit 'should be able to set access metadata' do
      #   7) Hydra::PCDM::Collection can have access metadata

      # TODO Write test

    end
  end

end
