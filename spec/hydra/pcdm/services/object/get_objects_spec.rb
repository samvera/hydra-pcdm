require 'spec_helper'

describe Hydra::PCDM::GetObjectsFromObject do

  subject { Hydra::PCDM::Object.new }

  let(:object1) { Hydra::PCDM::Object.new }
  let(:object2) { Hydra::PCDM::Object.new }

  describe '#call' do
    it 'should return empty array when no members' do
      expect(Hydra::PCDM::GetObjectsFromObject.call( subject )).to eq []
    end

    context 'with files and objects' do
      let(:file1) { subject.files.build }
      let(:file2) { subject.files.build }

      before do
        subject.save
        file1.content = "I'm a file"
        file2.content = "I am too"
        subject.child_objects += [object1, object2]
      end

      it 'should only return objects' do
        expect(Hydra::PCDM::GetObjectsFromObject.call( subject )).to eq [object1,object2]
      end
    end
  end

  context 'with unacceptable inputs' do
    before(:all) do
      @collection101   = Hydra::PCDM::Collection.new
      @file101         = Hydra::PCDM::File.new
      @non_PCDM_object = "I'm not a PCDM object"
      @af_base_object  = ActiveFedora::Base.new
    end

    context 'that are unacceptable parent objects' do
      let(:error_message) { 'parent_object must be a pcdm object' }

      it 'should NOT accept Hydra::PCDM::Collections as parent object' do
        expect{ Hydra::PCDM::GetObjectsFromObject.call( @collection101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Files as parent object' do
        expect{ Hydra::PCDM::GetObjectsFromObject.call( @file101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept non-PCDM objects as parent object' do
        expect{ Hydra::PCDM::GetObjectsFromObject.call( @non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept AF::Base objects as parent object' do
        expect{ Hydra::PCDM::GetObjectsFromObject.call( @af_base_object ) }.to raise_error(ArgumentError,error_message)
      end
    end
  end
end
