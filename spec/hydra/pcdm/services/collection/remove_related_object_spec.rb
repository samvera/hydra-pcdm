require 'spec_helper'

describe Hydra::PCDM::RemoveRelatedObjectFromCollection do

  subject { Hydra::PCDM::Collection.new }

  let(:object1) { Hydra::PCDM::Object.new }
  let(:object2) { Hydra::PCDM::Object.new }
  let(:object3) { Hydra::PCDM::Object.new }
  let(:object4) { Hydra::PCDM::Object.new }
  let(:object5) { Hydra::PCDM::Object.new }

  let(:collection1) { Hydra::PCDM::Collection.new }
  let(:collection2) { Hydra::PCDM::Collection.new }

  describe '#call' do
    context 'when it is the only related object' do
      before do
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object1 )
        expect( Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )).to eq [object1]
      end

      it 'should remove related object while changes are in memory' do
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, object1 ) ).to eq object1
        expect( Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )).to eq []
      end

      it 'should remove related object only when objects & collections and all changes are in memory' do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object3 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, object1 ) ).to eq object1
        expect( Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )).to eq []
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
        expect( Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )).to eq [object1,object2,object3,object4,object5]
      end

      it 'should remove first related object when changes are in memory' do
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, object1 ) ).to eq object1
        expect( Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )).to eq [object2,object3,object4,object5]
      end

      it 'should remove last related object when changes are in memory' do
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, object5 ) ).to eq object5
        expect( Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )).to eq [object1,object2,object3,object4]
      end

      it 'should remove middle related object when changes are in memory' do
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, object3 ) ).to eq object3
        expect( Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )).to eq [object1,object2,object4,object5]
      end

      it 'should remove middle related object when changes are saved' do
        subject.save
        expect( Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject.reload )).to eq [object1,object2,object3,object4,object5]
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, object3 ) ).to eq object3
        subject.save
        expect( Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject.reload )).to eq [object1,object2,object4,object5]
      end
    end

    context 'when related object is missing' do
      it 'should return empty array when 0 related objects and 0 collections and objects' do
      skip( "pending resolution of AF 864") do
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, object1 )).to eq []
      end
      end

      it 'should return empty array when 0 related objects, but has collections and objects and changes in memory' do
      skip( "pending resolution of AF 864") do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, object1 )).to eq []
      end
      end

      it 'should return empty array when other related objects and changes are in memory' do
      skip( "pending resolution of AF 864") do
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object2 )
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object4 )
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object5 )
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject, object3 )).to eq []
      end
      end

      it 'should return empty array when changes are saved' do
      skip( "pending resolution of AF 864") do
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object2 )
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object4 )
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object5 )
        subject.save
        expect( Hydra::PCDM::RemoveRelatedObjectFromCollection.call( subject.reload, object3 )).to eq []
      end
      end
    end
  end

  context 'with unacceptable inputs' do
    before(:all) do
      @collection101   = Hydra::PCDM::Collection.new
      @collection102   = Hydra::PCDM::Collection.new
      @object101       = Hydra::PCDM::Object.new
      @object102       = Hydra::PCDM::Object.new
      @file101         = Hydra::PCDM::File.new
      @non_PCDM_object = "I'm not a PCDM object"
      @af_base_object  = ActiveFedora::Base.new
    end

    context 'that are unacceptable child objects' do
      let(:error_message) { 'child_related_object must be a pcdm object' }

      it 'should NOT remove Hydra::PCDM::Collections from objects aggregation' do
        expect{ Hydra::PCDM::RemoveRelatedObjectFromCollection.call( @collection101, @collection102 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT remove Hydra::PCDM::Files from objects aggregation' do
        expect{ Hydra::PCDM::RemoveRelatedObjectFromCollection.call( @collection101, @file101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT remove non-PCDM objects from objects aggregation' do
        expect{ Hydra::PCDM::RemoveRelatedObjectFromCollection.call( @collection101, @non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT remove AF::Base objects from objects aggregation' do
        expect{ Hydra::PCDM::RemoveRelatedObjectFromCollection.call( @collection101, @af_base_object ) }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'that are unacceptable parent collections' do
      let(:error_message) { 'parent_collection must be a pcdm collection' }

      it 'should NOT accept Hydra::PCDM::Objects as parent collection' do
        expect{ Hydra::PCDM::RemoveRelatedObjectFromCollection.call( @object102, @object101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Files as parent collection' do
        expect{ Hydra::PCDM::RemoveRelatedObjectFromCollection.call( @file101, @object101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept non-PCDM objects as parent collection' do
        expect{ Hydra::PCDM::RemoveRelatedObjectFromCollection.call( @non_PCDM_object, @object101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept AF::Base objects as parent collection' do
        expect{ Hydra::PCDM::RemoveRelatedObjectFromCollection.call( @af_base_object, @object101 ) }.to raise_error(ArgumentError,error_message)
      end
    end
  end
end
