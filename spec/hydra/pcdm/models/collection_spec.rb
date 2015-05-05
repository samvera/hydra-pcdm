require 'spec_helper'

describe 'Hydra::PCDM::Collection' do

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

  # subject { Hydra::PCDM::Collection.new }

  # NOTE: This method is named 'members' because of the definition 'aggregates: members' in Hydra::PCDM::Collection

  describe '#collections=' do
    #   1) Hydra::PCDM::Collection can aggregate (pcdm:hasMember)  Hydra::PCDM::Collection (no infinite loop, e.g., A -> B -> C -> A)

    it 'should aggregate collections' do

      # TODO: This test needs refinement with before and after managing objects in fedora.

      collection1 = Hydra::PCDM::Collection.create
      collection2 = Hydra::PCDM::Collection.create
      collection3 = Hydra::PCDM::Collection.create
      
      collection1.collections = [collection2,collection3]
      collection1.save
      expect(collection1.collections).to eq [collection2,collection3]
    end

    xit 'should add a collection to the collections aggregation' do

      # TODO: This test needs refinement with before and after managing objects in fedora.

      collection1 = Hydra::PCDM::Collection.create
      collection2 = Hydra::PCDM::Collection.create
      collection3 = Hydra::PCDM::Collection.create
      collection4 = Hydra::PCDM::Collection.create

      collection1.collections = [collection2,collection3]
      collection1.save
      collection1.collections << collection4
      expect(collection1.collections).to eq [collection2,collection3,collection4]
    end

    xit 'should aggregate collections in a sub-collection of a collection' do

      # TODO: This test needs refinement with before and after managing objects in fedora.

      collection1 = Hydra::PCDM::Collection.create
      collection2 = Hydra::PCDM::Collection.create
      collection3 = Hydra::PCDM::Collection.create

      collection1.collections << collection2
      collection1.save
      collection2.collections << collection3
      expect(collection1.collections).to eq [collection2]
      expect(collection2.collections).to eq [collection3]
    end

    it 'should NOT aggregate Hydra::PCDM::Objects in collections aggregation' do
      collection1 = Hydra::PCDM::Collection.create
      object1 = Hydra::PCDM::Object.create
      expect{ collection1.collections = [object1] }.to raise_error(ArgumentError,"each collection must be a Hydra::PCDM::Collection")
    end

    it 'should NOT aggregate non-PCDM objects in collections aggregation' do
      #   4) Hydra::PCDM::Collection can NOT aggregate non-PCDM objects

      collection1 = Hydra::PCDM::Collection.create
      string1 = "non-PCDM object"
      expect{ collection1.collections = [string1] }.to raise_error(ArgumentError,"each collection must be a Hydra::PCDM::Collection")
    end

    xit 'should NOT allow infinite loop in chain of aggregated collections' do
      # DISALLOW:  A -> B -> C -> A

      # TODO Write test

    end
  end

  describe '#collections' do
    it 'should return empty array when no members' do
      collection1 = Hydra::PCDM::Collection.create
      collection1.save
      expect(collection1.collections).to eq []
    end

    it 'should return empty array when only objects are aggregated' do
      collection1 = Hydra::PCDM::Collection.create
      object1 = Hydra::PCDM::Object.create
      object2 = Hydra::PCDM::Object.create
      collection1.objects = [object1,object2]
      collection1.save
      expect(collection1.collections).to eq []
    end

    it 'should only return collections' do
      collection1 = Hydra::PCDM::Collection.create
      collection2 = Hydra::PCDM::Collection.create
      collection3 = Hydra::PCDM::Collection.create
      collection1.collections = [collection2,collection3]

      object1 = Hydra::PCDM::Object.create
      object2 = Hydra::PCDM::Object.create
      collection1.objects = [object1,object2]

      collection1.save
      expect(collection1.collections).to eq [collection2,collection3]
    end
  end


  describe '#objects=' do
    #   2) Hydra::PCDM::Collection can aggregate (pcdm:hasMember) Hydra::PCDM::Object

    it 'should aggregate objects' do

      # TODO: This test needs refinement with before and after managing objects in fedora.

      collection1 = Hydra::PCDM::Collection.create
      object1 = Hydra::PCDM::Object.create
      object2 = Hydra::PCDM::Object.create

      collection1.objects = [object1,object2]
      collection1.save
      expect(collection1.objects).to eq [object1,object2]
    end

    xit 'should add an object to the objects aggregation' do

      collection1 = Hydra::PCDM::Collection.create
      object1 = Hydra::PCDM::Object.create
      object2 = Hydra::PCDM::Object.create
      object3 = Hydra::PCDM::Object.create

      collection1.objects = [object1,object2]
      collection1.save
      collection1.objects << object3
      expect(collection1.objects).to eq [object1,object2,object3]
    end

    it 'should NOT aggregate Hydra::PCDM::Collection in objects aggregation' do
      collection1 = Hydra::PCDM::Collection.create
      collection2 = Hydra::PCDM::Collection.create
      expect{ collection1.objects = [collection2] }.to raise_error(ArgumentError,"each object must be a Hydra::PCDM::Object")
    end

    it 'should NOT aggregate non-PCDM objects in collections aggregation' do
      #   4) Hydra::PCDM::Collection can NOT aggregate non-PCDM objects

      collection1 = Hydra::PCDM::Collection.create
      string1 = "non-PCDM object"
      expect{ collection1.objects = [string1] }.to raise_error(ArgumentError,"each object must be a Hydra::PCDM::Object")
    end
  end

  describe '#objects' do
    it 'should return empty array when no members' do
      collection1 = Hydra::PCDM::Collection.create
      collection1.save
      expect(collection1.objects).to eq []
    end

    it 'should return empty array when only collections are aggregated' do
      collection1 = Hydra::PCDM::Collection.create
      collection2 = Hydra::PCDM::Collection.create
      collection3 = Hydra::PCDM::Collection.create
      collection1.collections = [collection2,collection3]
      collection1.save
      expect(collection1.objects).to eq []
    end

    it 'should only return objects' do
      collection1 = Hydra::PCDM::Collection.create
      collection2 = Hydra::PCDM::Collection.create
      collection3 = Hydra::PCDM::Collection.create
      collection1.collections = [collection2,collection3]

      object1 = Hydra::PCDM::Object.create
      object2 = Hydra::PCDM::Object.create
      collection1.objects = [object1,object2]

      collection1.save
      expect(collection1.objects).to eq [object1,object2]
    end
  end


  describe '#contains' do
    xit 'should NOT contain files' do
      #   5) Hydra::PCDM::Collection can NOT contain Hydra::PCDM::File

      # TODO Write test

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
