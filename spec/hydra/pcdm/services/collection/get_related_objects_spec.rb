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
end
