require 'spec_helper'

describe Hydra::PCDM::AddRelatedObjectToObject do

  let(:subject) { Hydra::PCDM::Object.new }

  describe '#call' do

    context 'with acceptable objects' do
      let(:object1) { Hydra::PCDM::Object.new }
      let(:object2) { Hydra::PCDM::Object.new }
      let(:object3) { Hydra::PCDM::Object.new }
      let(:file1)   { Hydra::PCDM::File.new }

      it 'should add objects to the related object set' do
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object1 )      # first add
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object2 )      # second add to same object
        related_objects = Hydra::PCDM::GetRelatedObjectsFromObject.call( subject )
        expect( related_objects.include? object1 ).to be true
        expect( related_objects.include? object2 ).to be true
        expect( related_objects.size ).to eq 2
      end

      it 'should not repeat objects in the related object set' do
      skip 'pending resolution of ActiveFedora issue #853' do
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object1 )      # first add
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object2 )      # second add to same object
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object1 )      # repeat an object replaces the object
        related_objects = Hydra::PCDM::GetRelatedObjectsFromObject.call( subject )
        expect( related_objects.include? object1 ).to be true
        expect( related_objects.include? object2 ).to be true
        expect( related_objects.size ).to eq 2
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

      context 'with unacceptable related objects' do
        let(:error_message) { 'child_related_object must be a pcdm object' }

        it 'should NOT aggregate Hydra::PCDM::Collection in objects aggregation' do
          expect{ Hydra::PCDM::AddRelatedObjectToObject.call( @object101, @collection101 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT aggregate Hydra::PCDM::Files in objects aggregation' do
          expect{ Hydra::PCDM::AddRelatedObjectToObject.call( @object101, @file1 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT aggregate non-PCDM objects in objects aggregation' do
          expect{ Hydra::PCDM::AddRelatedObjectToObject.call( @object101, @non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT aggregate AF::Base objects in objects aggregation' do
          expect{ Hydra::PCDM::AddRelatedObjectToObject.call( @object101, @af_base_object ) }.to raise_error(ArgumentError,error_message)
        end
      end

      context 'with unacceptable parent object' do
        let(:error_message) { 'parent_object must be a pcdm object' }

        it 'should NOT accept Hydra::PCDM::Collections as parent object' do
          expect{ Hydra::PCDM::AddRelatedObjectToObject.call( @collection101, @object101 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT accept Hydra::PCDM::Files as parent object' do
          expect{ Hydra::PCDM::AddRelatedObjectToObject.call( @file1, @object101 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT accept non-PCDM objects as parent object' do
          expect{ Hydra::PCDM::AddRelatedObjectToObject.call( @non_PCDM_object, @object101 ) }.to raise_error(ArgumentError,error_message)
        end

        it 'should NOT accept AF::Base objects as parent object' do
          expect{ Hydra::PCDM::AddRelatedObjectToObject.call( @af_base_object, @object101 ) }.to raise_error(ArgumentError,error_message)
        end
      end
    end
  end
end
