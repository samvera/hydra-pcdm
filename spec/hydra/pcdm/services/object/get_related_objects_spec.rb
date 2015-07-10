require 'spec_helper'

describe Hydra::PCDM::GetRelatedObjectsFromObject do

  subject { Hydra::PCDM::Object.new }

  let(:object1) { Hydra::PCDM::Object.new }
  let(:object2) { Hydra::PCDM::Object.new }

  describe '#call' do
    it 'should return empty array when no related object' do
      expect(Hydra::PCDM::GetRelatedObjectsFromObject.call( subject )).to eq []
    end

    it 'should return one related objects' do
      Hydra::PCDM::AddRelatedObjectToObject.call( subject, object2 )
      expect(Hydra::PCDM::GetRelatedObjectsFromObject.call( subject )).to eq [object2]
    end

    it 'should return related objects' do
      Hydra::PCDM::AddRelatedObjectToObject.call( subject, object1 )
      Hydra::PCDM::AddRelatedObjectToObject.call( subject, object2 )
      related_objects = Hydra::PCDM::GetRelatedObjectsFromObject.call( subject )
      expect( related_objects.include? object1 ).to be true
      expect( related_objects.include? object2 ).to be true
      expect( related_objects.size ).to eq 2
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
        expect{ Hydra::PCDM::GetRelatedObjectsFromObject.call( @collection101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Files as parent object' do
        expect{ Hydra::PCDM::GetRelatedObjectsFromObject.call( @file101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept non-PCDM objects as parent object' do
        expect{ Hydra::PCDM::GetRelatedObjectsFromObject.call( @non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept AF::Base objects as parent object' do
        expect{ Hydra::PCDM::GetRelatedObjectsFromObject.call( @af_base_object ) }.to raise_error(ArgumentError,error_message)
      end
    end
  end
end
