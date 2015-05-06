require 'spec_helper'

describe Hydra::PCDM::Object do

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
    #   1) Hydra::PCDM::Object can aggregate (pcdm:hasMember) Hydra::PCDM::Object

    it 'should aggregate objects' do

      # TODO: This test needs refinement with before and after managing objects in fedora.

      object1 = Hydra::PCDM::Object.create
      object2 = Hydra::PCDM::Object.create
      object3 = Hydra::PCDM::Object.create

      object1.objects = [object2,object3]
      object1.save
      expect(object1.objects).to eq [object2,object3]
    end

    xit 'should add an object to the objects aggregation' do

      object1 = Hydra::PCDM::Object.create
      object2 = Hydra::PCDM::Object.create
      object3 = Hydra::PCDM::Object.create
      object4 = Hydra::PCDM::Object.create

      object1.objects = [object2,object3]
      object1.save
      object1.objects << object4
      expect(object1.objects).to eq [object2,object3,object4]
    end

    it 'should NOT aggregate Hydra::PCDM::Collection in objects aggregation' do
      # 4) Hydra::PCDM::Object can NOT aggregate Hydra::PCDM::Collection

      object1 = Hydra::PCDM::Object.create
      collection1 = Hydra::PCDM::Collection.create
      expect{ object1.objects = [collection1] }.to raise_error(ArgumentError,"each object must be a Hydra::PCDM::Object")
    end

    it 'should NOT aggregate non-PCDM objects in objects aggregation' do
      #   5) Hydra::PCDM::Collection can NOT aggregate non-PCDM objects

      object1 = Hydra::PCDM::Object.create
      string1 = "non-PCDM object"
      expect{ object1.objects = [string1] }.to raise_error(ArgumentError,"each object must be a Hydra::PCDM::Object")
    end
  end

  describe '#objects' do
    it 'should return empty array when no members' do
      object1 = Hydra::PCDM::Object.create
      object1.save
      expect(object1.objects).to eq []
    end
  end

  describe '#files' do
    let(:object) { described_class.create }
    let(:file1) { object.files.build }
    let(:file2) { object.files.build }

    before do
      file1.content = "I'm a file"
      file2.content = "I am too"
      object.save!
    end

    subject { described_class.find(object.id).files }

    it { is_expected.to eq [file1, file2] }
  end

  describe '#related_files' do
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
