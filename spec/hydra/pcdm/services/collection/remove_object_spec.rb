require 'spec_helper'

describe Hydra::PCDM::RemoveObjectFromCollection do

  subject { Hydra::PCDM::Collection.create }

  let(:object1) { Hydra::PCDM::Object.create }
  let(:object2) { Hydra::PCDM::Object.create }
  let(:object3) { Hydra::PCDM::Object.create }
  let(:object4) { Hydra::PCDM::Object.create }
  let(:object5) { Hydra::PCDM::Object.create }

  let(:collection1) { Hydra::PCDM::Collection.create }
  let(:collection2) { Hydra::PCDM::Collection.create }

  describe '#call' do
    context 'when it is the only object' do
      before do
        Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
        subject.save
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject.reload )).to eq [object1]
      end

      it 'should remove object' do
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object1 ) ).to eq object1
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject.reload )).to eq []
      end

      it 'should remove object only when collections' do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object1 ) ).to eq object1
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject.reload )).to eq []
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq [collection1,collection2]
      end
    end

    context 'when multiple objects' do
      before do
        Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object3 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object4 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object5 )
        subject.save
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject.reload )).to eq [object1,object2,object3,object4,object5]
      end

      it 'should remove first object' do
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object1 ) ).to eq object1
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject.reload )).to eq [object2,object3,object4,object5]
      end

      it 'should remove last object' do
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object5 ) ).to eq object5
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject.reload )).to eq [object1,object2,object3,object4]
      end

      it 'should remove middle object' do
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object3 ) ).to eq object3
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject.reload )).to eq [object1,object2,object4,object5]
      end
    end

    context 'when object repeats' do
      before do
        Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object3 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object4 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object5 )
        subject.save
      end

      # TODO pending implementation of multiple objects

      it 'should remove first occurrence' do
        skip 'skipping this test because issue #102 needs to be addressed' do
        expect(Hydra::PCDM::GetObjectsFromCollection.call( subject.reload )).to eq [object1,object2,object3,object2,object4,object2,object5]
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object2 ) ).to eq object2
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject.reload )).to eq [object1,object3,object2,object4,object2,object5]
      end
      end

      it 'should remove last occurrence' do
        skip 'skipping this test because issue #102 needs to be addressed' do
        expect(Hydra::PCDM::GetObjectsFromCollection.call( subject.reload )).to eq [object1,object2,object3,object2,object4,object2,object5]
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object2, -1 ) ).to eq object2
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject.reload )).to eq [object1,object2,object3,object2,object4,object5]
      end
      end

      it 'should remove nth occurrence' do
        skip 'skipping this test because issue #102 needs to be addressed' do
        expect(Hydra::PCDM::GetObjectsFromCollection.call( subject.reload )).to eq [object1,object2,object3,object2,object4,object2,object5]
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object2, 2 ) ).to eq object2
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject.reload )).to eq [object1,object2,object3,object4,object2,object5]
      end
      end
    end

    context 'when object is missing' do
      it 'should return nil' do
        subject.save
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject.reload, object1 )).to be nil
      end

      it 'should return nil' do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
        subject.save
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject.reload, object1 )).to be nil
      end

      it 'should return nil' do
        Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object4 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object5 )
        subject.save
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject.reload, object3 )).to be nil
      end
    end
  end

  context 'with unacceptable objects' do
    let(:collection1)      { Hydra::PCDM::Collection.create }
    let(:file1)    { Hydra::PCDM::File.new }
    let(:non_PCDM_object) { "I'm not a PCDM object" }
    let(:af_base_object)  { ActiveFedora::Base.create }

    let(:error_type)    { ArgumentError }
    let(:error_message) { 'child_object must be a pcdm object' }

    it 'should NOT remove Hydra::PCDM::Collections from objects aggregation' do
      expect{ Hydra::PCDM::RemoveObjectFromCollection.call( subject, collection1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Files from objects aggregation' do
      expect{ Hydra::PCDM::RemoveObjectFromCollection.call( subject, file1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove non-PCDM objects from objects aggregation' do
      expect{ Hydra::PCDM::RemoveObjectFromCollection.call( subject, non_PCDM_object ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove AF::Base objects from objects aggregation' do
      expect{ Hydra::PCDM::RemoveObjectFromCollection.call( subject, af_base_object ) }.to raise_error(error_type,error_message)
    end
  end

  context 'with unacceptable parent collection' do
    let(:collection2)      { Hydra::PCDM::Collection.create }
    let(:object1)          { Hydra::PCDM::Object.create }
    let(:file1)            { Hydra::PCDM::File.new }
    let(:non_PCDM_object)  { "I'm not a PCDM object" }
    let(:af_base_object)   { ActiveFedora::Base.create }

    let(:error_type)    { ArgumentError }
    let(:error_message) { 'parent_collection must be a pcdm collection' }

    it 'should NOT accept Hydra::PCDM::Objects as parent collection' do
      expect{ Hydra::PCDM::RemoveObjectFromCollection.call( object1, collection2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept Hydra::PCDM::Files as parent collection' do
      expect{ Hydra::PCDM::RemoveObjectFromCollection.call( file1, collection2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept non-PCDM objects as parent collection' do
      expect{ Hydra::PCDM::RemoveObjectFromCollection.call( non_PCDM_object, collection2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept AF::Base objects as parent collection' do
      expect{ Hydra::PCDM::RemoveObjectFromCollection.call( af_base_object, collection2 ) }.to raise_error(error_type,error_message)
    end
  end
end
