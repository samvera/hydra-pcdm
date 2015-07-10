require 'spec_helper'

describe Hydra::PCDM::RemoveObjectFromCollection do

  subject { Hydra::PCDM::Collection.new }

  let(:object1) { Hydra::PCDM::Object.new }
  let(:object2) { Hydra::PCDM::Object.new }
  let(:object3) { Hydra::PCDM::Object.new }
  let(:object4) { Hydra::PCDM::Object.new }
  let(:object5) { Hydra::PCDM::Object.new }

  let(:collection1) { Hydra::PCDM::Collection.new }
  let(:collection2) { Hydra::PCDM::Collection.new }

  describe '#call' do
    context 'when it is the only object' do
      before do
        Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject )).to eq [object1]
      end

      it 'should remove object while changes are in memory' do
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object1 ) ).to eq object1
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject )).to eq []
      end

      it 'should remove object only when collections and all changes are in memory' do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object1 ) ).to eq object1
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject )).to eq []
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
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject )).to eq [object1,object2,object3,object4,object5]
      end

      it 'should remove first object when changes are in memory' do
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object1 ) ).to eq object1
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject )).to eq [object2,object3,object4,object5]
      end

      it 'should remove last object when changes are in memory' do
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object5 ) ).to eq object5
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject )).to eq [object1,object2,object3,object4]
      end

      it 'should remove middle object when changes are in memory' do
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object3 ) ).to eq object3
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject )).to eq [object1,object2,object4,object5]
      end

      it 'should remove middle object when changes are saved' do
        subject.save
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject.reload )).to eq [object1,object2,object3,object4,object5]
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object3 ) ).to eq object3
        subject.save
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
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject )).to eq [object1,object2,object3,object2,object4,object2,object5]
      end

      # TODO pending implementation of multiple objects

      it 'should remove first occurrence when changes in memory' do
        skip 'skipping this test because issue #102 needs to be addressed' do
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object2 ) ).to eq object2
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject )).to eq [object1,object3,object2,object4,object2,object5]
      end
      end

      it 'should remove last occurrence when changes in memory' do
        skip 'skipping this test because issue #102 needs to be addressed' do
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object2, -1 ) ).to eq object2
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject )).to eq [object1,object2,object3,object2,object4,object5]
      end
      end

      it 'should remove nth occurrence when changes in memory' do
        skip 'skipping this test because issue #102 needs to be addressed' do
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object2, 2 ) ).to eq object2
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject )).to eq [object1,object2,object3,object4,object2,object5]
      end
      end

      it 'should remove nth occurrence when changes are saved' do
        skip 'skipping this test because issue #102 needs to be addressed' do
          expect( Hydra::PCDM::GetObjectsFromCollection.call( subject )).to eq [object1,object2,object3,object2,object4,object2,object5]
          subject.save
          expect( Hydra::PCDM::GetObjectsFromCollection.call( subject.reload )).to eq [object1,object2,object3,object2,object4,object2,object5]

          expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object2, 2 ) ).to eq object2
          subject.save
          expect( Hydra::PCDM::GetObjectsFromCollection.call( subject.reload )).to eq [object1,object2,object3,object4,object2,object5]
        end
      end
    end

    context 'when object is missing' do
      it 'and 0 objects in collection should return nil' do
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object1 )).to be nil
      end

      it 'and multiple objects in collection should return nil when changes are in memory' do
        Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object4 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object5 )
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject, object3 )).to be nil
      end

      it 'should return nil when changes are saved' do
        Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object4 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object5 )
        subject.save
        expect( Hydra::PCDM::RemoveObjectFromCollection.call( subject.reload, object3 ) ).to be nil
      end
    end
  end

  context 'with unacceptable inputs' do
    before(:all) do
      @collection101   = Hydra::PCDM::Collection.new
      @collection102   = Hydra::PCDM::Collection.new
      @object101       = Hydra::PCDM::Object.new
      @file101         = Hydra::PCDM::File.new
      @non_PCDM_object = "I'm not a PCDM object"
      @af_base_object  = ActiveFedora::Base.new
    end

    context 'that are unacceptable child objects' do
      let(:error_message) { 'child_object must be a pcdm object' }

      it 'should NOT remove Hydra::PCDM::Collections from objects aggregation' do
        expect{ Hydra::PCDM::RemoveObjectFromCollection.call( @collection101, @collection102 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT remove Hydra::PCDM::Files from objects aggregation' do
        expect{ Hydra::PCDM::RemoveObjectFromCollection.call( @collection101, @file101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT remove non-PCDM objects from objects aggregation' do
        expect{ Hydra::PCDM::RemoveObjectFromCollection.call( @collection101, @non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT remove AF::Base objects from objects aggregation' do
        expect{ Hydra::PCDM::RemoveObjectFromCollection.call( @collection101, @af_base_object ) }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'that are unacceptable parent collections' do
      let(:error_message) { 'parent_collection must be a pcdm collection' }

      it 'should NOT accept Hydra::PCDM::Objects as parent collection' do
        expect{ Hydra::PCDM::RemoveObjectFromCollection.call( @object101, @collection101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Files as parent collection' do
        expect{ Hydra::PCDM::RemoveObjectFromCollection.call( @file101, @collection101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept non-PCDM objects as parent collection' do
        expect{ Hydra::PCDM::RemoveObjectFromCollection.call( @non_PCDM_object, @collection101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept AF::Base objects as parent collection' do
        expect{ Hydra::PCDM::RemoveObjectFromCollection.call( @af_base_object, @collection101 ) }.to raise_error(ArgumentError,error_message)
      end
    end
  end
end
