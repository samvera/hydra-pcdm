require 'spec_helper'

describe 'Hydra::PCDM::Collection' do

  # subject { Hydra::PCDM::Collection.new }

  # NOTE: This method is named 'members' because of the definition 'aggregates: members' in Hydra::PCDM::Collection
  describe '#collections' do
    #   1) Hydra::PCDM::Collection can aggregate Hydra::PCDM::Collection

    it 'should aggregate collections' do

      # TODO: This test needs refinement with before and after managing objects in fedora.

      # FIX: Failing with 'Unknown constant Member'.
      #      It is attempting to access constant Member because of the line in hydra/pcdm/collection.rb defining
      #            aggregates: members
      #      If you change aggregates: members to aggregates: collections, then it complains about constant Collection.

      collection1 = Hydra::PCDM::Collection.create
      collection2 = Hydra::PCDM::Collection.create
      collection3 = Hydra::PCDM::Collection.create

      collection1.collections = [collection2,collection3]
      collection1.save
      expect(collection1.collections).to eq [collection2,collection3]
    end

    it 'should add a collection to the collections aggregation' do

      # TODO: This test needs refinement with before and after managing objects in fedora.

      # FIX: Failing with 'Unknown constant Member'.
      #      It is attempting to access constant Member because of the line in hydra/pcdm/collection.rb defining
      #            aggregates: members
      #      If you change aggregates: members to aggregates: collections, then it complains about constant Collection.

      collection1 = Hydra::PCDM::Collection.create
      collection2 = Hydra::PCDM::Collection.create
      collection3 = Hydra::PCDM::Collection.create
      collection4 = Hydra::PCDM::Collection.create

      collection1.collections = [collection2,collection3]
      collection1.save
      collection1.collections << collection4
      expect(collection1.collections).to eq [collection2,collection3,collection4]
    end

    it 'should NOT aggregate Hydra::PCDM::Objects in collections aggregation' do
      collection1 = Hydra::PCDM::Collection.create
      object1 = Hydra::PCDM::Object.create
      expect{ collection1.collections = [object1] }.to raise_error(ArgumentError,"each collection must be a Hydra::PCDM::Collection")
    end

    it 'should NOT aggregate non-PCDM objects in collections aggregation' do
      #   3) Hydra::PCDM::Collection can NOT aggregate non-PCDM objects

      collection1 = Hydra::PCDM::Collection.create
      string1 = "non-PCDM object"
      expect{ collection1.collections = [string1] }.to raise_error(ArgumentError,"each collection must be a Hydra::PCDM::Collection")
    end
  end


  describe '#objects' do
    #   2) Hydra::PCDM::Collection can aggregate Hydra::PCDM::Object

    it 'should aggregate objects' do

      # TODO: This test needs refinement with before and after managing objects in fedora.

      # FIX: Failing with 'Unknown constant Member'.
      #      It is attempting to access constant Member because of the line in hydra/pcdm/collection.rb defining
      #            aggregates: members
      #      If you change aggregates: members to aggregates: objects, then it complains about constant Object.

      collection1 = Hydra::PCDM::Collection.create
      object1 = Hydra::PCDM::Object.create
      object2 = Hydra::PCDM::Object.create

      collection1.objects = [object1,object2]
      collection1.save
      expect(collection1.objects).to eq [object1,object2]
    end

    it 'should add an object to the objects aggregation' do

      # TODO: This test needs refinement with before and after managing objects in fedora.

      # FIX: Failing with 'Unknown constant Member'.
      #      It is attempting to access constant Member because of the line in hydra/pcdm/collection.rb defining
      #            aggregates: members
      #      If you change aggregates: members to aggregates: collections, then it complains about constant Collection.

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
      #   3) Hydra::PCDM::Collection can NOT aggregate non-PCDM objects

      collection1 = Hydra::PCDM::Collection.create
      string1 = "non-PCDM object"
      expect{ collection1.objects = [string1] }.to raise_error(ArgumentError,"each object must be a Hydra::PCDM::Object")
    end
  end


  describe '#contains' do
    xit 'should NOT contain files' do
      #   4) Hydra::PCDM::Collection can NOT contain Hydra::PCDM::File

      # TODO Write test

    end
  end


  describe '#METHOD_TO_SET_METADATA' do
    xit 'should be able to set descriptive metadata' do
      #   5) Hydra::PCDM::Collection can have descriptive metadata

      # TODO Write test

    end

    xit 'should be able to set access metadata' do
      #   6) Hydra::PCDM::Collection can have access metadata

      # TODO Write test

    end
  end

end
