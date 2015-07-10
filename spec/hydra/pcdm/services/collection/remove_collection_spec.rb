require 'spec_helper'

describe Hydra::PCDM::RemoveCollectionFromCollection do

  subject { Hydra::PCDM::Collection.new }

    let(:collection1) { Hydra::PCDM::Collection.new }
    let(:collection2) { Hydra::PCDM::Collection.new }
    let(:collection3) { Hydra::PCDM::Collection.new }
    let(:collection4) { Hydra::PCDM::Collection.new }
    let(:collection5) { Hydra::PCDM::Collection.new }

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
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection4 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection5 )
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq [collection1,collection2,collection3,collection4,collection5]
      end

      it 'should remove first collection when changes are in memory' do
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection1 ) ).to eq collection1
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq [collection2,collection3,collection4,collection5]
      end

      it 'should remove last collection when changes are in memory' do
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection5 ) ).to eq collection5
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq [collection1,collection2,collection3,collection4]
      end

      it 'should remove middle collection when changes are in memory' do
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection3 ) ).to eq collection3
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq [collection1,collection2,collection4,collection5]
      end

      it 'should remove middle collection when changes are saved' do
        subject.save
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject.reload )).to eq [collection1,collection2,collection3,collection4,collection5]
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection3 ) ).to eq collection3
        subject.save
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject.reload )).to eq [collection1,collection2,collection4,collection5]
      end
    end

    context 'when collection is missing' do
      it 'and 0 sub-collections should return nil' do
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection1 ) ).to be nil
      end

      it 'and multiple sub-collections should return nil when changes are in memory' do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection4 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection5 )
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection3 ) ).to be nil
      end

      it 'should return nil when changes are saved' do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection4 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection5 )
        subject.save
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject.reload, collection3 ) ).to be nil
      end
    end
  end

  context 'with unacceptable inputs' do
    before(:all) do
      @collection101   = Hydra::PCDM::Collection.new
      @object101       = Hydra::PCDM::Object.new
      @file101         = Hydra::PCDM::File.new
      @non_PCDM_object = "I'm not a PCDM object"
      @af_base_object  = ActiveFedora::Base.new
    end

    context 'that are unacceptable child collections' do
      let(:error_message) { 'child_collection must be a pcdm collection' }

      it 'should NOT remove Hydra::PCDM::Objects from collections aggregation' do
        expect{ Hydra::PCDM::RemoveCollectionFromCollection.call( @collection101, @object101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT remove Hydra::PCDM::Files from collections aggregation' do
        expect{ Hydra::PCDM::RemoveCollectionFromCollection.call( @collection101, @file101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT remove non-PCDM objects from collections aggregation' do
        expect{ Hydra::PCDM::RemoveCollectionFromCollection.call( @collection101, @non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT remove AF::Base objects from collections aggregation' do
        expect{ Hydra::PCDM::RemoveCollectionFromCollection.call( @collection101, @af_base_object ) }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'that are unacceptable parent collections' do
      let(:error_message) { 'parent_collection must be a pcdm collection' }

      it 'should NOT accept Hydra::PCDM::Objects as parent collection' do
        expect{ Hydra::PCDM::RemoveCollectionFromCollection.call( @object101, @collection101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Files as parent collection' do
        expect{ Hydra::PCDM::RemoveCollectionFromCollection.call( @file101, @collection101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept non-PCDM objects as parent collection' do
        expect{ Hydra::PCDM::RemoveCollectionFromCollection.call( @non_PCDM_object, @collection101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept AF::Base objects as parent collection' do
        expect{ Hydra::PCDM::RemoveCollectionFromCollection.call( @af_base_object, @collection101 ) }.to raise_error(ArgumentError,error_message)
      end
    end
  end
end
