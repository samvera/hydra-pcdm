require 'spec_helper'

describe Hydra::PCDM::AddObjectToObject do

  let(:subject) { Hydra::PCDM::Object.new }

  describe '#call' do
    context 'with acceptable objects' do
      let(:object1) { Hydra::PCDM::Object.new }
      let(:object2) { Hydra::PCDM::Object.new }
      let(:object3) { Hydra::PCDM::Object.new }
      let(:object4) { Hydra::PCDM::Object.new }
      let(:object5) { Hydra::PCDM::Object.new }

      it 'should add objects, sub-objects, and repeating objects' do
        Hydra::PCDM::AddObjectToObject.call( subject, object1 )      # first add
        Hydra::PCDM::AddObjectToObject.call( subject, object2 )      # second add to same object
        Hydra::PCDM::AddObjectToObject.call( subject, object1 )      # repeat an object
        Hydra::PCDM::AddObjectToObject.call( object1, object3 )  # add sub-object
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject ) ).to eq [object1,object2,object1]
        expect( Hydra::PCDM::GetObjectsFromObject.call( object1 ) ).to eq [object3]
      end

      describe 'adding objects that are ancestors' do
        let(:error_message) { "an object can't be an ancestor of itself" }

        context 'when the source object is the same' do
          it 'raises an error' do
            expect{ Hydra::PCDM::AddObjectToObject.call( object1, object1 )}.to raise_error(ArgumentError, error_message)
          end
        end

        before do
          Hydra::PCDM::AddObjectToObject.call( object1, object2 )
        end

        it 'raises and error' do
          expect{ Hydra::PCDM::AddObjectToObject.call( object2, object1 )}.to raise_error(ArgumentError, error_message)
        end

        context 'with more ancestors' do
          before do
            Hydra::PCDM::AddObjectToObject.call( object2, object3 )
          end

          it 'raises an error' do
            expect{ Hydra::PCDM::AddObjectToObject.call( object3, object1 )}.to raise_error(ArgumentError, error_message)
          end

          context 'with a more complicated example' do
            before do
              Hydra::PCDM::AddObjectToObject.call( object3, object4 )
              Hydra::PCDM::AddObjectToObject.call( object3, object5 )
            end

            it 'raises errors' do
              expect{ Hydra::PCDM::AddObjectToObject.call( object4, object1 )}.to raise_error(ArgumentError, error_message)
              expect{ Hydra::PCDM::AddObjectToObject.call( object4, object2 )}.to raise_error(ArgumentError, error_message)
            end
          end
        end
      end

      describe 'aggregates objects that implement Hydra::PCDM' do
        before do
          class DummyIncObject < ActiveFedora::Base
            include Hydra::PCDM::ObjectBehavior
          end
        end
        after { Object.send(:remove_const, :DummyIncObject) }
        let(:iobject1) { DummyIncObject.new }

        it 'should accept implementing object as a child' do
          Hydra::PCDM::AddObjectToObject.call( subject, iobject1 )
          expect( Hydra::PCDM::GetObjectsFromObject.call( subject ) ).to eq [iobject1]
        end
      end

      describe 'aggregates objects that extend Hydra::PCDM' do
        before do
          class DummyExtObject < Hydra::PCDM::Object
          end
        end
        after { Object.send(:remove_const, :DummyExtObject) }
        let(:eobject1) { DummyExtObject.new }

        it 'should accept extending object as a child' do
          Hydra::PCDM::AddObjectToObject.call( subject, eobject1 )
          expect( Hydra::PCDM::GetObjectsFromObject.call( subject ) ).to eq [eobject1]
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

      context 'with unacceptable objects' do
        let(:error_message) { 'child_object must be a pcdm object' }

        it 'should NOT aggregate Hydra::PCDM::Collection in objects aggregation' do
          expect{ Hydra::PCDM::AddObjectToObject.call( @object101, @collection101 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT aggregate Hydra::PCDM::Files in objects aggregation' do
          expect{ Hydra::PCDM::AddObjectToObject.call( @object101, @file1 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT aggregate non-PCDM objects in objects aggregation' do
          expect{ Hydra::PCDM::AddObjectToObject.call( @object101, @non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT aggregate AF::Base objects in objects aggregation' do
          expect{ Hydra::PCDM::AddObjectToObject.call( @object101, @af_base_object ) }.to raise_error(ArgumentError,error_message)
        end
      end

      context 'with unacceptable parent object' do
        let(:error_message) { 'parent_object must be a pcdm object' }

        it 'should NOT accept Hydra::PCDM::Collections as parent object' do
          expect{ Hydra::PCDM::AddObjectToObject.call( @collection101, @object101 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT accept Hydra::PCDM::Files as parent object' do
          expect{ Hydra::PCDM::AddObjectToObject.call( @file1, @object101 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT accept non-PCDM objects as parent object' do
          expect{ Hydra::PCDM::AddObjectToObject.call( @non_PCDM_object, @object101 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT accept AF::Base objects as parent object' do
          expect{ Hydra::PCDM::AddObjectToObject.call( @af_base_object, @object101 ) }.to raise_error(ArgumentError,error_message)
        end
      end
    end
  end
end
