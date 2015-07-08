require 'spec_helper'

describe Hydra::PCDM::AddCollectionToCollection do

  subject { Hydra::PCDM::Collection.new }

  describe '#call' do
    context 'with acceptable collections' do
      let(:collection1) { Hydra::PCDM::Collection.new }
      let(:collection2) { Hydra::PCDM::Collection.new }
      let(:collection3) { Hydra::PCDM::Collection.new }
      let(:collection4) { Hydra::PCDM::Collection.new }
      let(:object1)  { Hydra::PCDM::Object.new }
      let(:object2)  { Hydra::PCDM::Object.new }

      it 'should add collections, sub-collections, and repeating collections' do
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )      # first add
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )      # second add to same collection
        Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )      # repeat a collection
        Hydra::PCDM::AddCollectionToCollection.call( collection1, collection3 )  # add sub-collection
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject ) ).to eq [collection1,collection2,collection1]
        expect( Hydra::PCDM::GetCollectionsFromCollection.call( collection1 ) ).to eq [collection3]
      end

      context 'with collections and objects' do
        it 'should add an object to collection with collections and objects' do
          Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
          Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
          Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
          Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
          Hydra::PCDM::AddCollectionToCollection.call( subject, collection3 )
          expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject ) ).to eq [collection1,collection2,collection3]
        end
      end

      describe "adding collections that are ancestors" do
        let(:error_message) { "a collection can't be an ancestor of itself" }

        context "when the source collection is the same" do
          it "raises an error" do
            expect{ Hydra::PCDM::AddCollectionToCollection.call( subject, subject ) }.to raise_error(ArgumentError, error_message)
          end
        end

        before do
          Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
        end

        it "raises and error" do
          expect{ Hydra::PCDM::AddCollectionToCollection.call( collection1, subject ) }.to raise_error(ArgumentError, error_message)
        end

        context "with more ancestors" do
          before do
            Hydra::PCDM::AddCollectionToCollection.call( collection1, collection2 )
          end

          it "raises an error" do
            expect{ Hydra::PCDM::AddCollectionToCollection.call( collection2, subject ) }.to raise_error(ArgumentError, error_message)
          end

          context "with a more complicated example" do
            before do
              Hydra::PCDM::AddCollectionToCollection.call( collection2, collection3 )
              Hydra::PCDM::AddCollectionToCollection.call( collection2, collection4 )
            end

            it "raises errors" do
              expect{ Hydra::PCDM::AddCollectionToCollection.call( collection3, subject ) }.to raise_error(ArgumentError, error_message)
              expect{ Hydra::PCDM::AddCollectionToCollection.call( collection3, collection1 ) }.to raise_error(ArgumentError, error_message)
            end
          end
        end
      end

      describe 'aggregates collections that implement Hydra::PCDM' do
        before do
          class Kollection < ActiveFedora::Base
            include Hydra::PCDM::CollectionBehavior
          end
        end
        after { Object.send(:remove_const, :Kollection) }
        let(:kollection1) { Kollection.new }

        it 'should accept implementing collection as a child' do
          Hydra::PCDM::AddCollectionToCollection.call( subject, kollection1 )
          expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject ) ).to eq [kollection1]
        end

        it 'should accept implementing collection as a parent' do
          Hydra::PCDM::AddCollectionToCollection.call( kollection1, collection1 )
          expect( Hydra::PCDM::GetCollectionsFromCollection.call( kollection1 ) ).to eq [collection1]
        end
      end

      describe 'aggregates collections that extend Hydra::PCDM' do
        before do
          class Cullection < Hydra::PCDM::Collection
          end
        end
        after { Object.send(:remove_const, :Cullection) }
        let(:cullection1) { Cullection.new }

        it 'should accept extending collection as a child' do
          Hydra::PCDM::AddCollectionToCollection.call( subject, cullection1 )
          expect( Hydra::PCDM::GetCollectionsFromCollection.call( subject ) ).to eq [cullection1]
        end

        it 'should accept extending collection as a parent' do
          Hydra::PCDM::AddCollectionToCollection.call( cullection1, collection1 )
          expect( Hydra::PCDM::GetCollectionsFromCollection.call( cullection1 ) ).to eq [collection1]
        end
      end
    end

    context 'with unacceptable inputs' do
      before(:all) do
        @collection101   =  Hydra::PCDM::Collection.new
        @object101       = Hydra::PCDM::Object.new
        @file101         = Hydra::PCDM::File.new
        @non_PCDM_object = "I'm not a PCDM object"
        @af_base_object  = ActiveFedora::Base.new
      end

      context 'that are unacceptable child collections' do
        let(:error_message) { 'child_collection must be a pcdm collection' }

        it 'should NOT aggregate Hydra::PCDM::Objects in collections aggregation' do
          expect{ Hydra::PCDM::AddCollectionToCollection.call( @collection101, @object101 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT aggregate Hydra::PCDM::Files in collections aggregation' do
          expect{ Hydra::PCDM::AddCollectionToCollection.call( @collection101, @file101 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT aggregate non-PCDM objects in collections aggregation' do
          expect{ Hydra::PCDM::AddCollectionToCollection.call( @collection101, @non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT aggregate AF::Base objects in collections aggregation' do
          expect{ Hydra::PCDM::AddCollectionToCollection.call( @collection101, @af_base_object ) }.to raise_error(ArgumentError,error_message)
        end
      end

      context 'that are unacceptable parent collections' do
        let(:error_message) { 'parent_collection must be a pcdm collection' }

        it 'should NOT accept Hydra::PCDM::Objects as parent collection' do
          expect{ Hydra::PCDM::AddCollectionToCollection.call( @object101, @collection101 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT accept Hydra::PCDM::Files as parent collection' do
          expect{ Hydra::PCDM::AddCollectionToCollection.call( @file101, @collection101 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT accept non-PCDM objects as parent collection' do
          expect{ Hydra::PCDM::AddCollectionToCollection.call( @non_PCDM_object, @collection101 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT accept AF::Base objects as parent collection' do
          expect{ Hydra::PCDM::AddCollectionToCollection.call( @af_base_object, @collection101 ) }.to raise_error(ArgumentError,error_message)
        end
      end
    end
  end
end
