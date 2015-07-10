require 'spec_helper'

describe Hydra::PCDM::GetRelatedObjectsFromCollection do

  subject { Hydra::PCDM::Collection.new }

  let(:collection1) { Hydra::PCDM::Collection.new }
  let(:collection2) { Hydra::PCDM::Collection.new }

  let(:object1) { Hydra::PCDM::Object.new }
  let(:object2) { Hydra::PCDM::Object.new }

  describe '#call' do
    it 'should return empty array when no related object' do
      expect(Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )).to eq []
    end

    it 'should return one related objects' do
      Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object2 )
      expect(Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )).to eq [object2]
    end

    it 'should return related objects' do
      Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object1 )
      Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object2 )
      related_objects = Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )
      expect( related_objects.include? object1 ).to be true
      expect( related_objects.include? object2 ).to be true
      expect( related_objects.size ).to eq 2
    end
  end

  context 'with unacceptable inputs' do
    before(:all) do
      @object101       = Hydra::PCDM::Object.new
      @file101         = Hydra::PCDM::File.new
      @non_PCDM_object = "I'm not a PCDM object"
      @af_base_object  = ActiveFedora::Base.new
    end

    context 'that are unacceptable parent collections' do
      let(:error_message) { 'parent_collection must be a pcdm collection' }

      it 'should NOT accept Hydra::PCDM::Objects as parent collection' do
        expect{ Hydra::PCDM::GetRelatedObjectsFromCollection.call( @object101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Files as parent collection' do
        expect{ Hydra::PCDM::GetRelatedObjectsFromCollection.call( @file101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept non-PCDM objects as parent collection' do
        expect{ Hydra::PCDM::GetRelatedObjectsFromCollection.call( @non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept AF::Base objects as parent collection' do
        expect{ Hydra::PCDM::GetRelatedObjectsFromCollection.call( @af_base_object ) }.to raise_error(ArgumentError,error_message)
      end
    end
  end
end
