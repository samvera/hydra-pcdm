require 'spec_helper'

describe Hydra::PCDM::AddObjectToObject do

  let(:subject) { Hydra::PCDM::Object.create }

  describe '#call' do
    context 'with acceptable objects' do
      let(:object1) { Hydra::PCDM::Object.create }
      let(:object2) { Hydra::PCDM::Object.create }
      let(:object3) { Hydra::PCDM::Object.create }

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

      describe 'aggregates objects that implement Hydra::PCDM' do
        before do
          class Ahbject < ActiveFedora::Base
            include Hydra::PCDM::ObjectBehavior
          end
        end
        after { Object.send(:remove_const, :Ahbject) }
        let(:ahbject1) { Ahbject.create }

        it 'should accept implementing object as a child' do
          Hydra::PCDM::AddObjectToObject.call( subject, ahbject1 )
          subject.save
          expect( Hydra::PCDM::GetObjectsFromObject.call( subject ) ).to eq [ahbject1]
        end

      end

      describe 'aggregates objects that extend Hydra::PCDM' do
        before do
          class Awbject < Hydra::PCDM::Object
          end
        end
        after { Object.send(:remove_const, :Awbject) }
        let(:awbject1) { Awbject.create }

        it 'should accept extending object as a child' do
          Hydra::PCDM::AddObjectToObject.call( subject, awbject1 )
          subject.save
          expect( Hydra::PCDM::GetObjectsFromObject.call( subject ) ).to eq [awbject1]
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

  end

end
