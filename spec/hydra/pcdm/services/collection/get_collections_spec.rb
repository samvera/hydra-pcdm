require 'spec_helper'

describe Hydra::PCDM::GetCollectionsFromCollection do

  subject { Hydra::PCDM::Collection.create }

  let(:collection1) { Hydra::PCDM::Collection.create }
  let(:collection2) { Hydra::PCDM::Collection.create }

  let(:object1) { Hydra::PCDM::Object.create }
  let(:object2) { Hydra::PCDM::Object.create }

  describe '#call' do
    it 'should return empty array when no members' do
      subject.save
      expect(Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq []
    end

    it 'should return empty array when only objects are aggregated' do
      Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
      Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
      subject.save
      expect(Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq []
    end

    context 'with other collections & objects' do
      before do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
        subject.save
      end

      it 'should only return collections' do
        expect(Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq [collection1,collection2]
      end
    end
  end
end
