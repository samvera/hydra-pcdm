require 'spec_helper'

describe Hydra::PCDM::AddObjectToCollection do

  let(:subject) { Hydra::PCDM::Collection.new }

  describe '#call' do
    context 'with acceptable objects' do
      let(:object1)     { Hydra::PCDM::Object.new }
      let(:object2)     { Hydra::PCDM::Object.new }
      let(:object3)     { Hydra::PCDM::Object.new }
      let(:collection1) { Hydra::PCDM::Collection.new }
      let(:collection2) { Hydra::PCDM::Collection.new }

      it 'should add objects, sub-collections, and repeating collections' do
        Hydra::PCDM::AddObjectToCollection.call( subject, object1 )      # first add
        Hydra::PCDM::AddObjectToCollection.call( subject, object2 )      # second add to same collection
        Hydra::PCDM::AddObjectToCollection.call( subject, object1 )      # repeat an object
        expect( Hydra::PCDM::GetObjectsFromCollection.call( subject ) ).to eq [object1,object2,object1]
      end

      context 'with collections and objects' do
        it 'should add an object to collection with collections and objects' do
          Hydra::PCDM::AddObjectToCollection.call( subject, object1 )
          Hydra::PCDM::AddObjectToCollection.call( subject, object2 )
          Hydra::PCDM::AddCollectionToCollection.call( subject, collection1 )
          Hydra::PCDM::AddCollectionToCollection.call( subject, collection2 )
          Hydra::PCDM::AddObjectToCollection.call( subject, object3 )
          expect( Hydra::PCDM::GetObjectsFromCollection.call( subject ) ).to eq [object1,object2,object3]
        end
      end

      describe 'aggregates objects that implement Hydra::PCDM' do
        before do
          class Ahbject < ActiveFedora::Base
            include Hydra::PCDM::ObjectBehavior
          end
        end
        after { Object.send(:remove_const, :Ahbject) }
        let(:ahbject1) { Ahbject.new }

        it 'should accept implementing object as a child' do
          Hydra::PCDM::AddObjectToCollection.call( subject, ahbject1 )
          expect( Hydra::PCDM::GetObjectsFromCollection.call( subject ) ).to eq [ahbject1]
        end

      end

      describe 'aggregates objects that extend Hydra::PCDM' do
        before do
          class Awbject < Hydra::PCDM::Object
          end
        end
        after { Object.send(:remove_const, :Awbject) }
        let(:awbject1) { Awbject.new }

        it 'should accept extending object as a child' do
          Hydra::PCDM::AddObjectToCollection.call( subject, awbject1 )
          expect( Hydra::PCDM::GetObjectsFromCollection.call( subject ) ).to eq [awbject1]
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

      context 'with unacceptable objects' do
        let(:error_type1)    { ArgumentError }
        let(:error_message1) { 'Hydra::PCDM::Collection with ID:  was expected to pcdm_object?, but it was false' }
        let(:error_type2)    { NoMethodError }
        let(:error_message2) { /undefined method `pcdm_object\?' for .*/ }

        it 'should NOT aggregate Hydra::PCDM::Collection in objects aggregation' do
          expect{ Hydra::PCDM::AddObjectToCollection.call( @collection101, @collection102 ) }.to raise_error(error_type1,error_message1)
        end

        it 'should NOT aggregate Hydra::PCDM::Files in objects aggregation' do
          expect{ Hydra::PCDM::AddObjectToCollection.call( @collection101, @file101 ) }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate non-PCDM objects in objects aggregation' do
          expect{ Hydra::PCDM::AddObjectToCollection.call( @collection101, @non_PCDM_object ) }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate AF::Base objects in objects aggregation' do
          expect{ Hydra::PCDM::AddObjectToCollection.call( @collection101, @af_base_object ) }.to raise_error(error_type2,error_message2)
        end
      end
    end
  end
end
