require 'spec_helper'

describe Hydra::PCDM::AddObjectToObject do

  let(:subject) { Hydra::PCDM::Object.create }

  describe '#call' do
    context 'with acceptable objects' do
      let(:object1) { Hydra::PCDM::Object.create }
      let(:object2) { Hydra::PCDM::Object.create }
      let(:object3) { Hydra::PCDM::Object.create }
      let(:object4) { Hydra::PCDM::Object.create }
      let(:object5) { Hydra::PCDM::Object.create }

      it 'should add an object to empty object' do
        Hydra::PCDM::AddObjectToObject.call( subject, object1 )
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject ) ).to eq [object1]
      end

      it 'should add an object to an object with objects' do
        Hydra::PCDM::AddObjectToObject.call( subject, object1 )
        Hydra::PCDM::AddObjectToObject.call( subject, object2 )
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject ) ).to eq [object1,object2]
      end

      it 'should allow objects to repeat' do
        Hydra::PCDM::AddObjectToObject.call( subject, object1 )
        Hydra::PCDM::AddObjectToObject.call( subject, object2 )
        Hydra::PCDM::AddObjectToObject.call( subject, object1 )
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject ) ).to eq [object1,object2,object1]
      end

      it 'should aggregate objects in a sub-object of a object' do
        Hydra::PCDM::AddObjectToObject.call( subject, object1 )
        object1.save
        Hydra::PCDM::AddObjectToObject.call( object1, object2 )
        object2.save
        expect(subject.objects).to eq [object1]
        expect(object1.objects).to eq [object2]
      end

      context 'with files and objects' do
        let(:file1) { subject.files.build }
        let(:file2) { subject.files.build }

        before do
          file1.content = "I'm a file"
          file2.content = "I am too"
          Hydra::PCDM::AddObjectToObject.call( subject, object1 )
          Hydra::PCDM::AddObjectToObject.call( subject, object2 )
          subject.save!
        end

        it 'should add an object to an object with files and objects' do
          Hydra::PCDM::AddObjectToObject.call( subject, object3 )
          expect( Hydra::PCDM::GetObjectsFromObject.call( subject ) ).to eq [object1,object2,object3]
        end

        it 'should solrize member ids' do
          expect(subject.to_solr["objects_ssim"]).to include(object1.id,object2.id)
          # expect(subject.to_solr["objects_ssim"]).not_to include(file1.id,file21.id)
          # expect(subject.to_solr["files_ssim"]).not_to include(file1.id,file2.id)
          # expect(subject.to_solr["files_ssim"]).to include(object1.id,object2.id)
        end
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
          object1.save
        end

        it 'raises and error' do
          expect{ Hydra::PCDM::AddObjectToObject.call( object2, object1 )}.to raise_error(ArgumentError, error_message)
        end

        context 'with more ancestors' do
          before do
            Hydra::PCDM::AddObjectToObject.call( object2, object3 )
            object2.save
          end

          it 'raises an error' do
            expect{ Hydra::PCDM::AddObjectToObject.call( object3, object1 )}.to raise_error(ArgumentError, error_message)
          end

          context 'with a more complicated example' do
            before do
              Hydra::PCDM::AddObjectToObject.call( object3, object4 )
              Hydra::PCDM::AddObjectToObject.call( object3, object5 )
              object3.save
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
        let(:iobject1) { DummyIncObject.create }

        it 'should accept implementing object as a child' do
          Hydra::PCDM::AddObjectToObject.call( subject, iobject1 )
          subject.save
          expect( Hydra::PCDM::GetObjectsFromObject.call( subject ) ).to eq [iobject1]
        end
      end

      describe 'aggregates objects that extend Hydra::PCDM' do
        before do
          class DummyExtObject < Hydra::PCDM::Object
          end
        end
        after { Object.send(:remove_const, :DummyExtObject) }
        let(:eobject1) { DummyExtObject.create }

        it 'should accept extending object as a child' do
          Hydra::PCDM::AddObjectToObject.call( subject, eobject1 )
          subject.save
          expect( Hydra::PCDM::GetObjectsFromObject.call( subject ) ).to eq [eobject1]
        end
      end
    end

    context 'with unacceptable objects' do
      let(:collection1) { Hydra::PCDM::Collection.create }
      let(:file1) { Hydra::PCDM::File.new }
      let(:non_PCDM_object) { "I'm not a PCDM object" }
      let(:af_base_object)  { ActiveFedora::Base.create }

      let(:error_message) { 'child_object must be a pcdm object' }

      it 'should NOT aggregate Hydra::PCDM::Collection in objects aggregation' do
        expect{ Hydra::PCDM::AddObjectToObject.call( subject, collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Files in objects aggregation' do
        expect{ Hydra::PCDM::AddObjectToObject.call( subject, file1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate non-PCDM objects in objects aggregation' do
        expect{ Hydra::PCDM::AddObjectToObject.call( subject, non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate AF::Base objects in objects aggregation' do
        expect{ Hydra::PCDM::AddObjectToObject.call( subject, af_base_object ) }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'with unacceptable parent object' do
      let(:collection1)      { Hydra::PCDM::Collection.create }
      let(:object2)          { Hydra::PCDM::Object.create }
      let(:file1)            { Hydra::PCDM::File.new }
      let(:non_PCDM_object)  { "I'm not a PCDM object" }
      let(:af_base_object)   { ActiveFedora::Base.create }

      let(:error_message) { 'parent_object must be a pcdm object' }

      it 'should NOT accept Hydra::PCDM::Collections as parent object' do
        expect{ Hydra::PCDM::AddObjectToObject.call( collection1, object2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Files as parent object' do
        expect{ Hydra::PCDM::AddObjectToObject.call( file1, object2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept non-PCDM objects as parent object' do
        expect{ Hydra::PCDM::AddObjectToObject.call( non_PCDM_object, object2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept AF::Base objects as parent object' do
        expect{ Hydra::PCDM::AddObjectToObject.call( af_base_object, object2 ) }.to raise_error(ArgumentError,error_message)
      end
    end
  end
end
