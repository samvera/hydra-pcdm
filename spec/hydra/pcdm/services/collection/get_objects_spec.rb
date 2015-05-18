require 'spec_helper'

describe Hydra::PCDM::GetObjectsFromCollection do

  subject { Hydra::PCDM::Collection.create }

  let(:collection1) { Hydra::PCDM::Collection.create }
  let(:collection2) { Hydra::PCDM::Collection.create }

  let(:object1) { Hydra::PCDM::Object.create }
  let(:object2) { Hydra::PCDM::Object.create }

  describe '#call' do
    it 'should return empty array when no members' do
      subject.save
      expect(Hydra::PCDM::GetObjectsFromCollection.call( subject )).to eq []
    end

    it 'should return empty array when only collections are aggregated' do
      Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
      Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
      subject.save
      expect(Hydra::PCDM::GetObjectsFromCollection.call( subject )).to eq []
    end

    context 'with collections and objects' do
      before do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
        subject.save
      end

      it 'should only return related objects' do
        expect(Hydra::PCDM::GetObjectsFromCollection.call( subject )).to eq [object1,object2]
      end
   end
  end
end
