require 'spec_helper'

describe Hydra::PCDM::Object do

  let(:object1) { Hydra::PCDM::Object.create }
  let(:object2) { Hydra::PCDM::Object.create }
  let(:object3) { Hydra::PCDM::Object.create }
  let(:object4) { Hydra::PCDM::Object.create }
  let(:object5) { Hydra::PCDM::Object.create }

  let(:file1) { Hydra::PCDM::File.new }
  let(:file2) { Hydra::PCDM::File.new }

  let(:collection1) { Hydra::PCDM::Collection.create }
  let(:non_PCDM_object)  { "I'm not a PCDM object" }
  let(:af_base_object)   { ActiveFedora::Base.create }

  # TEST the following behaviors...
  #   1) Hydra::PCDM::Object can aggregate (pcdm:hasMember) Hydra::PCDM::Object
  #   2) Hydra::PCDM::Collection can aggregate (ore:aggregates) Hydra::PCDM::Object  (Object related to the Object)

  #   3) Hydra::PCDM::Object can contain (pcdm:hasFile) Hydra::PCDM::File
  #   4) Hydra::PCDM::Object can contain (pcdm:hasRelatedFile) Hydra::PCDM::File

  #   5) Hydra::PCDM::Object can NOT aggregate Hydra::PCDM::Collection
  #   6) Hydra::PCDM::Object can NOT aggregate non-PCDM object

  #   7) Hydra::PCDM::Object can have descriptive metadata
  #   8) Hydra::PCDM::Object can have access metadata

  describe '#objects=' do
    it 'should aggregate objects' do
      object1.objects = [object2, object3]
      object1.save
      expect(object1.objects).to eq [object2, object3]
    end

    context 'when aggregating other objects' do
      before do
        object1.objects = [object2, object3]
        object1.save
      end
      subject { object1.objects }
      it { is_expected.to eq [object2, object3] }
      it 'solrizes member ids' do
        expect(object1.to_solr["objects_ssim"]).to include(object3.id, object2.id)
      end
    end

    it 'should aggregate objects in a sub-object of a object' do
      object1.objects = [object2]
      object1.save
      object2.objects = [object3]
      object2.save
      expect(object1.objects).to eq [object2]
      expect(object2.objects).to eq [object3]
    end

    context 'with unacceptable objects' do
      let(:error_message) { "each object must be a pcdm object" }

      it 'should NOT aggregate Hydra::PCDM::Collections in objects aggregation' do
        expect{ object1.objects = [collection1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate non-PCDM objects in objects aggregation' do
        expect{ object1.objects = [non_PCDM_object] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate AF::Base objects in objects aggregation' do
        expect{ object1.objects = [af_base_object] }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'with acceptable objects' do
      describe 'aggregates objects that implement Hydra::PCDM' do
        before do
          class DummyIncObject < ActiveFedora::Base
            include Hydra::PCDM::ObjectBehavior
          end
        end
        after { Object.send(:remove_const, :DummyIncObject) }
        let(:iobject1) { DummyIncObject.create }
        before do
          object1.objects = [iobject1]
          object1.save
        end
        subject { object1.objects }
        it { is_expected.to eq [iobject1]}
      end

      describe 'aggregates collections that extend Hydra::PCDM' do
        before do
          class DummyExtObject < Hydra::PCDM::Object
          end
        end
        after { Object.send(:remove_const, :DummyExtObject) }
        let(:eobject1) { DummyExtObject.create }
        before do
          object1.objects = [eobject1]
          object1.save
        end
        subject { object1.objects }
        it { is_expected.to eq [eobject1]}
      end
    end

    describe "adding objects that are ancestors" do
      let(:error_message) { "an object can't be an ancestor of itself" }

      context "when the source object is the same" do
        it "raises an error" do
          expect{ object1.objects = [object1]}.to raise_error(ArgumentError, error_message)
        end
      end

      before do
        object1.objects = [object2]
        object1.save
      end

      it "raises and error" do
        expect{ object2.objects = [object1]}.to raise_error(ArgumentError, error_message)
      end

      context "with more ancestors" do
        before do
          object2.objects = [object3]
          object2.save
        end

        it "raises an error" do
          expect{ object3.objects = [object1]}.to raise_error(ArgumentError, error_message)
        end

        context "with a more complicated example" do
          before do
            object3.objects = [object4, object5]
            object3.save
          end

          it "raises errors" do
            expect{ object4.objects = [object1]}.to raise_error(ArgumentError, error_message)
            expect{ object4.objects = [object2]}.to raise_error(ArgumentError, error_message)
          end
        end
      end
    end
  end

  describe '#objects' do
    it 'should return empty array when no members' do
      object1.save
      expect(object1.objects).to eq []
    end
  end

  describe 'Related objects' do
    before do
      object1.related_objects = [object2]
      object1.save
    end

    it 'persists' do
      expect(object1.reload.related_objects).to eq [object2]
    end
  end

  describe '#files' do
    let(:object) { described_class.create }
    let(:file1) { object.files.build }
    let(:file2) { object.files.build }

    before do
      file1.content = "I'm a file"
      file2.content = "I am too"
      object.save!
    end

    subject { described_class.find(object.id).files }

    it { is_expected.to eq [file1, file2] }
  end

end
