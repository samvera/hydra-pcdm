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
        subject.save
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject.reload )).to eq [collection1]
      end

      it 'should remove collection' do
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection1 ) ).to eq collection1
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject.reload )).to eq []
      end

      it 'should remove collection only when objects' do
        Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection1 ) ).to eq collection1
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject.reload )).to eq []
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
        subject.save
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject.reload )).to eq [collection1,collection2,collection3,collection4,collection5]
      end

      it 'should remove first collection' do
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection1 ) ).to eq collection1
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject.reload )).to eq [collection2,collection3,collection4,collection5]
      end

      it 'should remove last collection' do
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection5 ) ).to eq collection5
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject.reload )).to eq [collection1,collection2,collection3,collection4]
      end

      it 'should remove middle collection' do
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject, collection3 ) ).to eq collection3
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject.reload )).to eq [collection1,collection2,collection4,collection5]
      end
    end

    context 'when collection is missing' do
      it 'should return nil' do
        subject.save
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject.reload, collection1 ) ).to be nil
      end

      it 'should return nil' do
        Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
        subject.save
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject.reload, collection1 ) ).to be nil
      end

      it 'should return nil' do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection4 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection5 )
        subject.save
        expect( Hydra::PCDM::RemoveCollectionFromCollection.call( subject.reload, collection3 ) ).to be nil
      end
    end
  end

  context 'with unacceptable collections' do
    let(:object1)  { Hydra::PCDM::Object.new }
    let(:file1)    { Hydra::PCDM::File.new }
    let(:non_PCDM_object) { "I'm not a PCDM object" }
    let(:af_base_object)  { ActiveFedora::Base.new }

    let(:error_type)    { ArgumentError }
    let(:error_message) { 'child_collection must be a pcdm collection' }

    it 'should NOT remove Hydra::PCDM::Objects from collections aggregation' do
      expect{ Hydra::PCDM::RemoveCollectionFromCollection.call( subject, object1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Files from collections aggregation' do
      expect{ Hydra::PCDM::RemoveCollectionFromCollection.call( subject, file1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove non-PCDM objects from collections aggregation' do
      expect{ Hydra::PCDM::RemoveCollectionFromCollection.call( subject, non_PCDM_object ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove AF::Base objects from collections aggregation' do
      expect{ Hydra::PCDM::RemoveCollectionFromCollection.call( subject, af_base_object ) }.to raise_error(error_type,error_message)
    end
  end

  context 'with unacceptable parent collection' do
    let(:collection2)      { Hydra::PCDM::Collection.new }
    let(:object1)          { Hydra::PCDM::Object.new }
    let(:file1)            { Hydra::PCDM::File.new }
    let(:non_PCDM_object)  { "I'm not a PCDM object" }
    let(:af_base_object)   { ActiveFedora::Base.new }

    let(:error_type)    { ArgumentError }
    let(:error_message) { 'parent_collection must be a pcdm collection' }

    it 'should NOT accept Hydra::PCDM::Objects as parent collection' do
      expect{ Hydra::PCDM::RemoveCollectionFromCollection.call( object1, collection2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept Hydra::PCDM::Files as parent collection' do
      expect{ Hydra::PCDM::RemoveCollectionFromCollection.call( file1, collection2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept non-PCDM objects as parent collection' do
      expect{ Hydra::PCDM::RemoveCollectionFromCollection.call( non_PCDM_object, collection2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept AF::Base objects as parent collection' do
      expect{ Hydra::PCDM::RemoveCollectionFromCollection.call( af_base_object, collection2 ) }.to raise_error(error_type,error_message)
    end
  end
end
