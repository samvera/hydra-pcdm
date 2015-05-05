require 'spec_helper'

describe Hydra::PCDM::Collection do

  let(:collection1) { Hydra::PCDM::Collection.create }
  let(:collection2) { Hydra::PCDM::Collection.create }
  let(:collection3) { Hydra::PCDM::Collection.create }
  let(:collection4) { Hydra::PCDM::Collection.create }

  let(:object1) { Hydra::PCDM::Object.create }
  let(:object2) { Hydra::PCDM::Object.create }
  let(:object3) { Hydra::PCDM::Object.create }

  let(:non_pcdm_object) { "non-PCDM object" }

  # TEST the following behaviors...
  #   1) Hydra::PCDM::Collection can aggregate (pcdm:hasMember)  Hydra::PCDM::Collection (no infinite loop, e.g., A -> B -> C -> A)
  #   2) Hydra::PCDM::Collection can aggregate (pcdm:hasMember)  Hydra::PCDM::Object
  #   3) Hydra::PCDM::Collection can aggregate (ore:aggregates) Hydra::PCDM::Object  (Object related to the Collection)

  #   4) Hydra::PCDM::Collection can NOT aggregate non-PCDM object
  #   5) Hydra::PCDM::Collection can NOT contain (pcdm:hasFile)  Hydra::PCDM::File

  #   6) Hydra::PCDM::Collection can have descriptive metadata
  #   7) Hydra::PCDM::Collection can have access metadata


  # TODO need test to validate type is Hydra::PCDM::Collection
  # TODO need test for 3) Hydra::PCDM::Collection can aggregate (ore:aggregates) Hydra::PCDM::Object

  describe "#collections" do
    subject {collection1.collections }
    describe "collections aggregating collections" do
      before do
        collection1.collections = [collection2,collection3]
        collection1.save
      end
      it { is_expected.to eq [collection2,collection3] }

      describe "adding additional collections" do
        context "when redefining the entire set" do 
          before do
            collection1.collections = [collection2,collection3,collection4]
            collection1.save
          end
          it { is_expected.to eq [collection2,collection3,collection4] }
        end
        context "when using the << operator" do
          it "should add the collection to the existing set" do
            pending "<< operator fails for ActiveFedora::Aggregation::Association"
            collection1.collections << collection4
            collection1.save
            expect(subject).to eq [collection2,collection3,collection4]
          end
        end
      end
    end

    describe "collections in a collection in a collection" do
      before do
        collection1.collections = [collection2]
        collection1.save
        collection2.collections = [collection3]
        collection2.save
      end
      it "nests collections" do
        expect(collection1.collections).to eq [collection2]
        expect(collection2.collections).to eq [collection3]
      end
      it "avoids circular nesting" do
        pending "I have no idea how to do this one"
        expect{ collection3.collections = [collection1]}.to raise_error
      end
    end

    describe "collections aggregating classes that are Hydra::PCDM::Collection types" do
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

    it 'should NOT aggregate Hydra::PCDM::Objects in collections aggregation' do
      expect{ collection1.collections = [object1] }.to raise_error(ArgumentError,"each collection must be a Hydra::PCDM::Collection")
    end

    it 'should NOT aggregate non-PCDM objects in collections aggregation' do
      expect{ collection1.collections = [non_pcdm_object] }.to raise_error(ArgumentError,"each collection must be a Hydra::PCDM::Collection")
    end
  end


  describe "#objects" do
    describe "a collection aggregating objects" do
      before do
        collection1.objects = [object1,object2]
        collection1.save
      end
      subject { collection1.objects }
      it { is_expected.to eq [object1,object2] }
    end

    describe "adding objects to the objects aggregation" do
      before do
        collection1.objects = [object1,object2]
        collection1.save
        collection1.objects = [object1,object2,object3]
        collection1.save
      end
      subject { collection1.objects }
      it { is_expected.to eq [object1,object2,object3] }
    end

    it "should NOT aggregate Hydra::PCDM::Collection in objects aggregation" do
      expect{ collection1.objects = [collection2] }.to raise_error(ArgumentError,"each object must be a Hydra::PCDM::Object")
    end

    it "should NOT aggregate non-PCDM objects in collections aggregation" do
      expect{ collection1.objects = [non_pcdm_object] }.to raise_error(ArgumentError,"each object must be a Hydra::PCDM::Object")
    end
  end

  describe "#contains" do
    it "should NOT contain files" do
      # 5) Hydra::PCDM::Collection can NOT contain Hydra::PCDM::File
      skip "need to write test"
    end
  end

  describe "#METHOD_TO_SET_METADATA" do
    it "should be able to set descriptive metadata" do
      # 6) Hydra::PCDM::Collection can have descriptive metadata
      skip "need to write test"
    end

    it "should be able to set access metadata" do
      # 7) Hydra::PCDM::Collection can have access metadata
      skip "need to write test"
    end
  end

end
