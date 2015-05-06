require 'spec_helper'

describe 'Hydra::PCDM::Object' do

  # TEST the following behaviors...
  #   1) Hydra::PCDM::Object can aggregate (pcdm:hasMember) Hydra::PCDM::Object

  #   2) Hydra::PCDM::Object can contain (pcdm:hasFile) Hydra::PCDM::File
  #   3) Hydra::PCDM::Object can contain (pcdm:hasRelatedFile) Hydra::PCDM::File

  #   4) Hydra::PCDM::Object can NOT aggregate Hydra::PCDM::Collection
  #   5) Hydra::PCDM::Object can NOT aggregate non-PCDM object

  #   6) Hydra::PCDM::Object can have descriptive metadata
  #   7) Hydra::PCDM::Object can have access metadata

  # subject { Hydra::PCDM::Object.new }

  # NOTE: This method is named 'members' because of the definition 'aggregates: members' in Hydra::PCDM::Object
  describe '#objects=' do

    xit 'should aggregate objects' do
      #   1) Hydra::PCDM::Object can aggregate (pcdm:hasMember) Hydra::PCDM::Object

      # TODO Write test

    end

    xit 'should NOT aggregate collections' do
      #   4) Hydra::PCDM::Object can NOT aggregate Hydra::PCDM::Collection

      # TODO Write test

    end

    xit 'should NOT aggregate non-PCDM objects' do
      #   5) Hydra::PCDM::Object can NOT aggregate non-PCDM object

      # TODO Write test

    end
  end

  describe '#objects' do

  end

  describe '#contains' do
    xit 'should contain files' do
      #   2) Hydra::PCDM::Object can contain (pcdm:hasFile) Hydra::PCDM::File

      # TODO Write test

    end

    xit 'should contain related files' do
      #   3) Hydra::PCDM::Object can contain (pcdm:hasRelatedFile) Hydra::PCDM::File

      # TODO Write test

    end
  end



  describe '#METHOD_TO_SET_METADATA' do
    xit 'should be able to set descriptive metadata' do
      #   6) Hydra::PCDM::Collection can have descriptive metadata

      # TODO Write test

    end

    xit 'should be able to set access metadata' do
      #   7) Hydra::PCDM::Object can have descriptive metadata

      # TODO Write test

    end
  end

end

