require 'spec_helper'

describe Hydra::PCDM::GetRelatedObjectsFromCollection do

  subject { Hydra::PCDM::Collection.create }

  let(:collection1) { Hydra::PCDM::Collection.create }
  let(:collection2) { Hydra::PCDM::Collection.create }

  let(:object1) { Hydra::PCDM::Object.create }
  let(:object2) { Hydra::PCDM::Object.create }

  describe '#call' do
    it 'should return empty array when no related object' do
      subject.save
      expect(Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )).to eq []
    end

    context 'with collections and objects' do
      before do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
        subject.save
      end

      it 'should return empty array when only collections and object are aggregated' do
        expect(Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )).to eq []
      end

      it 'should only return objects' do
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object2 )
        expect(Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )).to eq [object2]
      end
   end
  end
end
