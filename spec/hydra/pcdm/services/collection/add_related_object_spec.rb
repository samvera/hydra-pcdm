require 'spec_helper'

describe Hydra::PCDM::AddRelatedObjectToCollection do

  let(:subject) { Hydra::PCDM::Collection.new }

  describe '#call' do

    context 'with acceptable collections' do
      let(:object1) { Hydra::PCDM::Object.new }
      let(:object2) { Hydra::PCDM::Object.new }
      let(:object3) { Hydra::PCDM::Object.new }
      let(:object4) { Hydra::PCDM::Object.new }
      let(:collection1) { Hydra::PCDM::Collection.new }
      let(:collection2) { Hydra::PCDM::Collection.new }

      it 'should add objects to the related object set' do
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object1 )      # first add
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object2 )      # second add to same collection
        related_objects = Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )
        expect( related_objects.include? object1 ).to be true
        expect( related_objects.include? object2 ).to be true
        expect( related_objects.size ).to eq 2
      end

      it 'should not repeat objects in the related object set' do
        skip 'pending resolution of ActiveFedora issue #853' do
          Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object1 )      # first add
          Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object2 )      # second add to same collection
          Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object1 )      # repeat an object replaces the object
          related_objects = Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )
          expect( related_objects.include? object1 ).to be true
          expect( related_objects.include? object2 ).to be true
          expect( related_objects.size ).to eq 2
        end
      end

      context 'with collections and objects' do
        before do
          Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
          Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
          Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
          Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
          Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object3 )
        end

        it 'should add a related object to a collection with collections and objects' do
          Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object4 )
          related_objects = Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )
          expect( related_objects.include? object3 ).to be true
          expect( related_objects.include? object4 ).to be true
          expect( related_objects.size ).to eq 2
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

      context 'with unacceptable related objects' do
        let(:error_message) { 'child_related_object must be a pcdm object' }

        it 'should NOT aggregate Hydra::PCDM::Collection in objects aggregation' do
          expect{ Hydra::PCDM::AddRelatedObjectToCollection.call( @collection102, @collection101 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT aggregate Hydra::PCDM::Files in objects aggregation' do
          expect{ Hydra::PCDM::AddRelatedObjectToCollection.call( @collection102, @file1 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT aggregate non-PCDM objects in objects aggregation' do
          expect{ Hydra::PCDM::AddRelatedObjectToCollection.call( @collection102, @non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT aggregate AF::Base objects in objects aggregation' do
          expect{ Hydra::PCDM::AddRelatedObjectToCollection.call( @collection102, @af_base_object ) }.to raise_error(ArgumentError,error_message)
        end
      end

      context 'with unacceptable parent object' do
        let(:error_message) { 'parent_collection must be a pcdm collection' }

        it 'should NOT accept Hydra::PCDM::Collections as parent object' do
          expect{ Hydra::PCDM::AddRelatedObjectToCollection.call( @object102, @object101 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT accept Hydra::PCDM::Files as parent object' do
          expect{ Hydra::PCDM::AddRelatedObjectToCollection.call( @file1, @object101 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT accept non-PCDM objects as parent object' do
          expect{ Hydra::PCDM::AddRelatedObjectToCollection.call( @non_PCDM_object, @object101 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT accept AF::Base objects as parent object' do
          expect{ Hydra::PCDM::AddRelatedObjectToCollection.call( @af_base_object, @object101 ) }.to raise_error(ArgumentError,error_message)
        end
      end
    end
  end
end
