require 'spec_helper'

describe Hydra::PCDM::AddRelatedObjectToCollection do

  let(:subject) { Hydra::PCDM::Collection.create }

  describe '#call' do

    context 'with acceptable collections' do
      let(:object1) { Hydra::PCDM::Object.create }
      let(:object2) { Hydra::PCDM::Object.create }
      let(:object3) { Hydra::PCDM::Object.create }
      let(:object4) { Hydra::PCDM::Object.create }
      let(:collection1) { Hydra::PCDM::Collection.create }
      let(:collection2) { Hydra::PCDM::Collection.create }

      it 'should add a related object to empty collection' do
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object1 )
        expect( Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject ) ).to eq [object1]
      end

      it 'should add a related object to collection with related objects' do
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object2 )
        related_objects = Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )
        expect( related_objects.include? object1 ).to be true
        expect( related_objects.include? object2 ).to be true
        expect( related_objects.size ).to eq 2
      end

      context 'with collections and objects' do
        before do
          Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
          Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
          Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
          Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
          Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object3 )
          subject.save
        end

        it 'should add an object to collection with collections and objects' do
          Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object4 )
          related_objects = Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )
          expect( related_objects.include? object3 ).to be true
          expect( related_objects.include? object4 ).to be true
          expect( related_objects.size ).to eq 2
        end

        it 'should solrize member ids' do
          expect(subject.to_solr["objects_ssim"]).to include(object1.id,object2.id)
          expect(subject.to_solr["objects_ssim"]).not_to include(collection2.id,collection1.id,object3.id,object4.id)
          expect(subject.to_solr["collections_ssim"]).to include(collection2.id,collection1.id)
          expect(subject.to_solr["collections_ssim"]).not_to include(object1.id,object2.id,object3.id,object4.id)
        end
      end
    end

    context 'with unacceptable objects' do
      let(:collection1) { Hydra::PCDM::Collection.create }
      let(:file1) { Hydra::PCDM::File.new }
      let(:non_PCDM_object) { "I'm not a PCDM object" }
      let(:af_base_object)  { ActiveFedora::Base.create }

      let(:error_message) { 'child_related_object must be a pcdm object' }

      it 'should NOT aggregate Hydra::PCDM::Collection in related objects aggregation' do
        expect{ Hydra::PCDM::AddRelatedObjectToCollection.call( subject, collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Files in related objects aggregation' do
        expect{ Hydra::PCDM::AddRelatedObjectToCollection.call( subject, file1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate non-PCDM objects in related objects aggregation' do
        expect{ Hydra::PCDM::AddRelatedObjectToCollection.call( subject, non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate AF::Base objects in related objects aggregation' do
        expect{ Hydra::PCDM::AddRelatedObjectToCollection.call( subject, af_base_object ) }.to raise_error(ArgumentError,error_message)
      end

    end

    context 'with invalid bahaviors' do
      let(:object1) { Hydra::PCDM::Object.create }
      let(:object2) { Hydra::PCDM::Object.create }

      xit 'should NOT allow related objects to repeat' do
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object1 )
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object2 )
        Hydra::PCDM::AddRelatedObjectToCollection.call( subject, object1 )
        related_objects = Hydra::PCDM::GetRelatedObjectsFromCollection.call( subject )
        expect( related_objects.include? object1 ).to be true
        expect( related_objects.include? object2 ).to be true
        expect( related_objects.size ).to eq 2
      end
    end
  end
end
