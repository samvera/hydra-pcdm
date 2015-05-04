require 'spec_helper'

describe 'Hydra::PCDM::Object' do

  # subject { Hydra::PCDM::Object.new }

  # NOTE: This method is named 'members' because of the definition 'aggregates: members' in Hydra::PCDM::Object
  describe '#members' do

    xit 'should NOT aggregate collections' do
      #   1) Hydra::PCDM::Object can NOT aggregate Hydra::PCDM::Collection

      # TODO Write test

    end

    xit 'should aggregate objects' do
      #   2) Hydra::PCDM::Object can aggregate Hydra::PCDM::Object

      # TODO Write test

    end

    xit 'should NOT aggregate non-PCDM objects' do
      #   3) Hydra::PCDM::Object can NOT aggregate non-PCDM objects

      # TODO Write test

    end
  end


  describe '#contains' do
    xit 'should NOT contain files' do
      #   4) Hydra::PCDM::Object can contain Hydra::PCDM::File

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

