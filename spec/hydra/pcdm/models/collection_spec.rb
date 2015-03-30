require 'spec_helper'

describe 'Hydra::PCDM::Collection' do

  # subject { Hydra::PCDM::Collection.new }

  # NOTE: This method is named 'members' because of the definition 'aggregates: members' in Hydra::PCDM::Collection
  describe '#members' do
    it 'should aggregate collections' do
      #   1) PCDM::Collection can aggregate PCDM::Collection

      # TODO: This test needs refinement with before and after managing objects in fedora.

      # FIX: Failing with 'Unknown constant Member'.
      #      It is attempting to access constant Member because of the line in hydra/pcdm/collection.rb defining
      #            aggregates: members
      #      If you change aggregates: members to aggregates: collections, then it complains about constant Collection.

      collection1 = Hydra::PCDM::Collection.create
# binding.pry
      collection2 = Hydra::PCDM::Collection.create
# binding.pry

      collection1.members = [collection2]
      collection1.save
      expect(collection1.members).to eq [collection2]

    end

    xit 'should aggregate objects' do
      #   2) PCDM::Collection can aggregate PCDM::Object

      # TODO Write test

    end

    xit 'should NOT aggregate non-PCDM objects' do
      #   3) PCDM::Collection can NOT aggregate non-PCDM objects

      # TODO Write test

    end
  end


  describe '#contains' do
    xit 'should NOT contain files' do
      #   4) PCDM::Collection can NOT contain PCDM::File

      # TODO Write test

    end
  end


  describe '#METHOD_TO_SET_METADATA' do
    xit 'should be able to set descriptive metadata' do
      #   5) PCDM::Collection can have descriptive metadata

      # TODO Write test

    end

    xit 'should be able to set access metadata' do
      #   6) PCDM::Collection can have access metadata

      # TODO Write test

    end
  end

end
