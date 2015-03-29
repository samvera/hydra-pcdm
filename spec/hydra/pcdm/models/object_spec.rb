require 'spec_helper'

describe 'Hydra::PCDM::Object' do

  # subject { Hydra::PCDM::Object.new }

  # NOTE: This method is named 'members' because of the definition 'aggregates: members' in Hydra::PCDM::Object
  describe '#members' do

    xit 'should NOT aggregate collections' do
      #   1) PCDM::Object can NOT aggregate PCDM::Collection

      # TODO Write test

    end

    xit 'should aggregate objects' do
      #   2) PCDM::Object can aggregate PCDM::Object

      # TODO Write test

    end

    xit 'should NOT aggregate non-PCDM objects' do
      #   3) PCDM::Object can NOT aggregate non-PCDM objects

      # TODO Write test

    end
  end


  describe '#contains' do
    xit 'should NOT contain files' do
      #   4) PCDM::Object can contain PCDM::File

      # TODO Write test

    end
  end

end
