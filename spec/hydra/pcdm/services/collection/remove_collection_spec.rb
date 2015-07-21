require 'spec_helper'

describe Hydra::PCDM::RemoveCollectionFromCollection do

  subject { Hydra::PCDM::Collection.new }

    let(:collection1) { Hydra::PCDM::Collection.new }
    let(:collection2) { Hydra::PCDM::Collection.new }
    let(:collection3) { Hydra::PCDM::Collection.new }

    let(:object1) { Hydra::PCDM::Object.new }
    let(:object2) { Hydra::PCDM::Object.new }


  describe '#call' do
    context 'when it is the only collection' do

      before do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq [collection1]
      end

      it 'should remove collection while changes are in memory' do
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection1 ) ).to eq collection1
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq []
      end

      it 'should remove collection only when objects and all changes are in memory' do
        Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection1 ) ).to eq collection1
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq []
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject )).to eq [object1,object2]
      end
    end

    context 'when multiple collections' do
      before do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection3 )
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq [collection1,collection2,collection3]
      end

      it 'should remove first collection when changes are in memory' do
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection1 ) ).to eq collection1
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq [collection2,collection3]
      end

      it 'should remove last collection when changes are in memory' do
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection3 ) ).to eq collection3
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq [collection1,collection2]
      end

      it 'should remove middle collection when changes are in memory' do
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection2 ) ).to eq collection2
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq [collection1,collection3]
      end

      it 'should remove middle collection when changes are saved' do
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq [collection1,collection2,collection3]
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection2 ) ).to eq collection2
        subject.save
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq [collection1,collection3]
      end
    end

    context 'when collection is missing' do
      it 'and 0 sub-collections should return empty array' do
      skip( "pending resolution of AF-agg 55 and AF 864") do
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection1 ) ).to eq []
      end
      end

      it 'and multiple sub-collections should return empty array when changes are in memory' do
      skip( "pending resolution of AF-agg 55 and AF 864") do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection3 )
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection2 ) ).to eq []
      end
      end

      it 'should return empty array when changes are saved' do
      skip( "pending resolution of AF-agg 55 and AF 864") do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection3 )
        subject.save
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection2 ) ).to eq []
      end
      end
    end
  end
end
