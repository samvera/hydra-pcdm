require 'spec_helper'

describe Hydra::PCDM::RemoveRelatedObjectFromCollection do

  subject { Hydra::PCDM::Collection.create }

  let(:object1) { Hydra::PCDM::Object.create }
  let(:object2) { Hydra::PCDM::Object.create }
  let(:object3) { Hydra::PCDM::Object.create }
  let(:object4) { Hydra::PCDM::Object.create }
  let(:object5) { Hydra::PCDM::Object.create }

  let(:collection1) { Hydra::PCDM::Collection.create }
  let(:collection2) { Hydra::PCDM::Collection.create }

  describe '#call' do
    context 'when it is the only related object' do
      before do
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object1 )
        subject.save
        expect( Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject.reload )).to eq [object1]
      end

      it 'should remove related object' do
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, object1 ) ).to eq object1
        expect( Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject.reload )).to eq []
      end

      it 'should remove related object only when objects & collections' do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object3 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, object1 ) ).to eq object1
        expect( Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject.reload )).to eq []
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject )).to eq [collection1,collection2]
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject )).to eq [object3,object2]
      end
    end

    context 'when multiple related objects' do
      before do
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object2 )
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object3 )
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object4 )
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object5 )
        subject.save
        expect( Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject.reload )).to eq [object1,object2,object3,object4,object5]
      end

      it 'should remove first related object' do
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, object1 ) ).to eq object1
        expect( Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject.reload )).to eq [object2,object3,object4,object5]
      end

      it 'should remove last related object' do
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, object5 ) ).to eq object5
        expect( Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject.reload )).to eq [object1,object2,object3,object4]
      end

      it 'should remove middle related object' do
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, object3 ) ).to eq object3
        expect( Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject.reload )).to eq [object1,object2,object4,object5]
      end
    end

    context 'when related object is missing' do
      it 'should return nil when 0 related objects and 0 collections and objects' do
        subject.save
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject.reload, object1 )).to be nil
      end

      it 'should return nil when 0 related objects, but has collections and objects' do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
        subject.save
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject.reload, object1 )).to be nil
      end

      it 'should return nil when other related objects' do
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object2 )
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object4 )
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object5 )
        subject.save
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject.reload, object3 )).to be nil
      end
    end
  end

  context 'with unacceptable related objects' do
    let(:collection1)     { Hydra::PCDM::Collection.create }
    let(:file1)           { Hydra::PCDM::File.new }
    let(:non_PCDM_object) { "I'm not a PCDM object" }
    let(:af_base_object)  { ActiveFedora::Base.create }

    let(:error_type)    { ArgumentError }
    let(:error_message) { 'child_related_object must be a pcdm object' }

    it 'should NOT remove Hydra::PCDM::Collections from related_objects aggregation' do
      expect{ Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, collection1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Files from related_objects aggregation' do
      expect{ Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, file1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove non-PCDM objects from related_objects aggregation' do
      expect{ Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, non_PCDM_object ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove AF::Base objects from related_objects aggregation' do
      expect{ Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, af_base_object ) }.to raise_error(error_type,error_message)
    end
  end

  context 'with unacceptable parent collection' do
    let(:object2)          { Hydra::PCDM::Object.create }
    let(:object1)          { Hydra::PCDM::Object.create }
    let(:file1)            { Hydra::PCDM::File.new }
    let(:non_PCDM_object)  { "I'm not a PCDM object" }
    let(:af_base_object)   { ActiveFedora::Base.create }

    let(:error_type)    { ArgumentError }
    let(:error_message) { 'parent_collection must be a pcdm collection' }

    it 'should NOT accept Hydra::PCDM::Objects as parent collection' do
      expect{ Hydra::PCDM::RemoveRelatedObjectFromCollection.call( object1, object2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept Hydra::PCDM::Files as parent collection' do
      expect{ Hydra::PCDM::RemoveRelatedObjectFromCollection.call( file1, object2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept non-PCDM objects as parent collection' do
      expect{ Hydra::PCDM::RemoveRelatedObjectFromCollection.call( non_PCDM_object, object2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept AF::Base objects as parent collection' do
      expect{ Hydra::PCDM::RemoveRelatedObjectFromCollection.call( af_base_object, object2 ) }.to raise_error(error_type,error_message)
    end
  end
end
