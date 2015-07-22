require 'spec_helper'

describe Hydra::PCDM::Object do

  describe "#child_object_ids" do
    let(:child1) { described_class.new(id: '1') }
    let(:child2) { described_class.new(id: '2') }
    let(:object) { described_class.new }
    before { object.child_objects = [child1, child2] }

    subject { object.child_object_ids }

    it { is_expected.to eq ["1", "2"] }
  end

  describe '#child_objects=, +=, <<' do
    context 'with acceptable child objects' do
      let(:object1) { described_class.new }
      let(:object2) { described_class.new }
      let(:object3) { described_class.new }
      let(:object4) { described_class.new }
      let(:object5) { described_class.new }

      it 'should be empty when no objects have been added' do
        expect( subject.child_objects ).to eq []
      end

      it 'should add objects' do
        subject.child_objects = [object1,object2]
        subject.child_objects << object3
        subject.child_objects += [object4,object5]
        expect( subject.child_objects ).to eq [object1,object2,object3,object4,object5]
      end

      it 'should allow sub-objects' do
        subject.child_objects = [object1,object2]
        object1.child_objects = [object3]
        expect( subject.child_objects ).to eq [object1,object2]
        expect( object1.child_objects ).to eq [object3]
      end

      it 'should allow repeating objects' do
        subject.child_objects = [object1,object2]
        subject.child_objects << object1
        expect( subject.child_objects ).to eq [object1,object2,object1]
      end

      describe 'adding objects that are ancestors' do
        let(:error_type)    { ArgumentError }
        let(:error_message) { 'Hydra::PCDM::Object with ID:  failed to pass AncestorChecker validation' }

        context 'when the source object is the same' do
          it 'raises an error' do
            expect { object1.child_objects = [object1] }.to raise_error(error_type, error_message)
            expect { object1.child_objects += [object1] }.to raise_error(error_type, error_message)
            expect { object1.child_objects << [object1] }.to raise_error(error_type, error_message)
          end
        end

        before do
          object1.child_objects = [object2]
        end

        it 'raises an error' do
          expect { object2.child_objects += [object1] }.to raise_error(error_type, error_message)
          expect { object2.child_objects << [object1] }.to raise_error(error_type, error_message)
          expect { object2.child_objects = [object1] }.to raise_error(error_type, error_message)
        end

        context 'with more ancestors' do
          before do
            object2.child_objects = [object3]
          end

          it 'raises an error' do
            expect { object3.child_objects << [object1] }.to raise_error(error_type, error_message)
            expect { object3.child_objects = [object1] }.to raise_error(error_type, error_message)
            expect { object3.child_objects += [object1] }.to raise_error(error_type, error_message)
          end

          context 'with a more complicated example' do
            before do
              object3.child_objects = [object4,object5]
            end

            it 'raises errors' do
              expect { object4.child_objects = [object1] }.to raise_error(error_type, error_message)
              expect { object4.child_objects += [object1] }.to raise_error(error_type, error_message)
              expect { object4.child_objects << [object1] }.to raise_error(error_type, error_message)

              expect { object4.child_objects = [object2] }.to raise_error(error_type, error_message)
              expect { object4.child_objects += [object2] }.to raise_error(error_type, error_message)
              expect { object4.child_objects << [object2] }.to raise_error(error_type, error_message)
            end
          end
        end
      end
    end

    context 'with unacceptable child objects' do
      before(:all) do
        @collection101   = Hydra::PCDM::Collection.new
        @object101       = Hydra::PCDM::Object.new
        @file101         = Hydra::PCDM::File.new
        @non_PCDM_object = "I'm not a PCDM object"
        @af_base_object  = ActiveFedora::Base.new
      end

      let(:error_type1)    { ArgumentError }
      let(:error_message1) { 'Hydra::PCDM::Collection with ID:  was expected to pcdm_object?, but it was false' }
      let(:error_type2)    { NoMethodError }
      let(:error_message2) { /undefined method `pcdm_object\?' for .*/ }

      it 'should NOT aggregate Hydra::PCDM::Collection in objects aggregation' do
        expect { @object101.child_objects = [@collection101] }.to raise_error(error_type1,error_message1)
        expect { @object101.child_objects += [@collection101] }.to raise_error(error_type1,error_message1)
        expect { @object101.child_objects << @collection101 }.to raise_error(error_type1,error_message1)
      end

      it 'should NOT aggregate Hydra::PCDM::Files in objects aggregation' do
        expect { @object101.child_objects += [@file1] }.to raise_error(error_type2,error_message2)
        expect { @object101.child_objects << @file1 }.to raise_error(error_type2,error_message2)
        expect { @object101.child_objects = [@file1] }.to raise_error(error_type2,error_message2)
      end

      it 'should NOT aggregate non-PCDM objects in objects aggregation' do
        expect { @object101.child_objects << @non_PCDM_object }.to raise_error(error_type2,error_message2)
        expect { @object101.child_objects = [@non_PCDM_object] }.to raise_error(error_type2,error_message2)
        expect { @object101.child_objects += [@non_PCDM_object] }.to raise_error(error_type2,error_message2)
      end

      it 'should NOT aggregate AF::Base objects in objects aggregation' do
        expect { @object101.child_objects = [@af_base_object] }.to raise_error(error_type2,error_message2)
        expect { @object101.child_objects += [@af_base_object] }.to raise_error(error_type2,error_message2)
        expect { @object101.child_objects << @af_base_object }.to raise_error(error_type2,error_message2)
      end
    end
  end

  describe '#members=, +=, <<' do
    context 'with acceptable child objects' do
      let(:object1) { described_class.new }
      let(:object2) { described_class.new }
      let(:object3) { described_class.new }
      let(:object4) { described_class.new }
      let(:object5) { described_class.new }

      it 'should add objects' do
        subject.members = [object1,object2]
        subject.members << object3
        subject.members += [object4,object5]
        expect( subject.members ).to eq [object1,object2,object3,object4,object5]
      end

      it 'should allow sub-objects' do
        subject.members = [object1,object2]
        object1.members = [object3]
        expect( subject.members ).to eq [object1,object2]
        expect( object1.members ).to eq [object3]
      end

      it 'should allow repeating objects' do
        subject.members = [object1,object2,object1]
        expect( subject.members ).to eq [object1,object2,object1]
      end

      describe 'adding objects that are ancestors' do
        let(:error_type)    { ArgumentError }
        let(:error_message) { 'Hydra::PCDM::Object with ID:  failed to pass AncestorChecker validation' }

        context 'when the source object is the same' do
          it 'raises an error' do
            expect { object1.members = [object1] }.to raise_error(error_type, error_message)
            expect { object1.members += [object1] }.to raise_error(error_type, error_message)
            expect { object1.members << [object1] }.to raise_error(error_type, error_message)
          end
        end

        before do
          object1.members = [object2]
        end

        it 'raises an error' do
          expect { object2.members += [object1] }.to raise_error(error_type, error_message)
          expect { object2.members << [object1] }.to raise_error(error_type, error_message)
          expect { object2.members = [object1] }.to raise_error(error_type, error_message)
        end

        context 'with more ancestors' do
          before do
            object2.members = [object3]
          end

          it 'raises an error' do
            expect { object3.members << [object1] }.to raise_error(error_type, error_message)
            expect { object3.members = [object1] }.to raise_error(error_type, error_message)
            expect { object3.members += [object1] }.to raise_error(error_type, error_message)
          end

          context 'with a more complicated example' do
            before do
              object3.members = [object4,object5]
            end

            it 'raises errors' do
              expect { object4.members = [object1] }.to raise_error(error_type, error_message)
              expect { object4.members += [object1] }.to raise_error(error_type, error_message)
              expect { object4.members << [object1] }.to raise_error(error_type, error_message)

              expect { object4.members = [object2] }.to raise_error(error_type, error_message)
              expect { object4.members += [object2] }.to raise_error(error_type, error_message)
              expect { object4.members << [object2] }.to raise_error(error_type, error_message)
            end
          end
        end
      end
    end

    context 'with unacceptable child objects' do
      before(:all) do
        @collection101   = Hydra::PCDM::Collection.new
        @object101       = Hydra::PCDM::Object.new
        @file101         = Hydra::PCDM::File.new
        @non_PCDM_object = "I'm not a PCDM object"
        @af_base_object  = ActiveFedora::Base.new
      end

      let(:error_type1)    { ActiveFedora::AssociationTypeMismatch }
      let(:error_message1) { /(<ActiveFedora::Base:[\d\s\w]{16}>|\s*) is not a PCDM object./ }

      let(:error_type2)    { ActiveFedora::AssociationTypeMismatch }
      let(:error_message2) { /ActiveFedora::Base\(#\d+\) expected, got NilClass\(#[\d]+\)/ }

      let(:error_type3)    { ActiveFedora::AssociationTypeMismatch }
      let(:error_message3) { /ActiveFedora::Base\(#\d+\) expected, got String\(#[\d]+\)/ }

      it 'should NOT aggregate Hydra::PCDM::Collection in members aggregation' do
        expect { @object101.members = [@collection101] }.to raise_error(error_type1,error_message1)
        expect { @object101.members += [@collection101] }.to raise_error(error_type1,error_message1)
        expect { @object101.members << @collection101 }.to raise_error(error_type1,error_message1)
      end
      it 'should NOT aggregate Hydra::PCDM::Files in members aggregation' do
        expect { @object101.members += [@file1] }.to raise_error(error_type2,error_message2)
        expect { @object101.members << @file1 }.to raise_error(error_type2,error_message2)
        expect { @object101.members = [@file1] }.to raise_error(error_type2,error_message2)
      end

      it 'should NOT aggregate non-PCDM objects in members aggregation' do
        expect { @object101.members << @non_PCDM_object }.to raise_error(error_type3,error_message3)
        expect { @object101.members = [@non_PCDM_object] }.to raise_error(error_type3,error_message3)
        expect { @object101.members += [@non_PCDM_object] }.to raise_error(error_type3,error_message3)
      end

      it 'should NOT aggregate non-PCDM AF::Base objects in members aggregation' do
        expect { @object101.members = [@af_base_object] }.to raise_error(error_type1,error_message1)
        expect { @object101.members += [@af_base_object] }.to raise_error(error_type1,error_message1)
        expect { @object101.members << @af_base_object }.to raise_error(error_type1,error_message1)
      end
    end
  end

  context 'when aggregated by other objects' do
    before do
      # Using before(:all) and instance variable because regular :let syntax had a significant impact on performance
      # All of the tests in this context are describing idempotent behavior, so isolation between examples isn't necessary.
      @collection1 = Hydra::PCDM::Collection.new
      @collection2 = Hydra::PCDM::Collection.new
      @parent_object = Hydra::PCDM::Object.new
      @object =  Hydra::PCDM::Object.new
      @collection1.members = [@object]
      @collection2.members = [@object]
      @parent_object.members = [@object]
      allow(@object).to receive(:id).and_return("banana")
      proxies = [
        build_proxy(container: @collection1),
        build_proxy(container: @collection2),
        build_proxy(container: @parent_object)
      ]
      allow(ActiveFedora::Aggregation::Proxy).to receive(:where).with(proxyFor_ssim: @object.id).and_return(proxies)
    end

    describe 'parents' do
      subject { @object.parents }
      it "finds all nodes that aggregate the object with hasMember" do
        expect(subject).to include(@collection1, @collection2, @parent_object)
      end
    end

    describe 'parent_objects' do
      subject { @object.parent_objects }
      it "finds objects that aggregate the object with hasMember" do
        expect(subject).to eq [@parent_object]
      end
    end
    describe 'parent_collections' do
      subject { @object.parent_collections }
      it "finds collections that aggregate the object with hasMember" do
        expect(subject).to include(@collection1, @collection2)
        expect(subject.count).to eq 2
      end
    end
    def build_proxy(container:)
      instance_double(ActiveFedora::Aggregation::Proxy, container: container)
    end
  end

  describe 'Related objects' do
    context 'with acceptable objects' do
      let(:object1) { Hydra::PCDM::Object.new }
      let(:object2) { Hydra::PCDM::Object.new }
      let(:object3) { Hydra::PCDM::Object.new }
      let(:file1)   { Hydra::PCDM::File.new }

      it 'should return empty array when no related object' do
        expect( subject.related_objects ).to eq []
      end

      it 'should add objects to the related object set' do
        subject.related_objects << object1      # first add
        subject.related_objects << object2      # second add to same object
        subject.save
        related_objects = subject.reload.related_objects
        expect( related_objects.include? object1 ).to be true
        expect( related_objects.include? object2 ).to be true
        expect( related_objects.size ).to eq 2
      end

      it 'should not repeat objects in the related object set' do
      skip 'pending resolution of ActiveFedora issue #853' do
        subject.related_objects << object1      # first add
        subject.related_objects << object2      # second add to same object
        subject.related_objects << object1      # repeat an object replaces the object
        related_objects = subject.related_objects
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
          skip 'pending resolution of Hydra::PCDM issue #153' do
            expect{ @object101.related_objects << @collection101 }.to raise_error(ArgumentError,error_message)
          end
        end

        it 'should NOT aggregate Hydra::PCDM::Files in objects aggregation' do
          skip 'pending resolution of Hydra::PCDM issue #153' do
            expect{ @object101.related_objects << @file1 }.to raise_error(ArgumentError,error_message)
          end
        end

        it 'should NOT aggregate non-PCDM objects in objects aggregation' do
          skip 'pending resolution of Hydra::PCDM issue #153' do
            expect{ @object101.related_objects << @non_PCDM_object }.to raise_error(ArgumentError,error_message)
          end
        end

        it 'should NOT aggregate AF::Base objects in objects aggregation' do
          skip 'pending resolution of Hydra::PCDM issue #153' do
            expect{ @object101.related_objects << @af_base_object }.to raise_error(ArgumentError,error_message)
          end
        end
      end

      context 'with unacceptable parent object' do
        it 'should NOT accept Hydra::PCDM::Files as parent object' do
          expect{ @file1.related_objects << @object101 }.to raise_error(NoMethodError)
        end

        it 'should NOT accept non-PCDM objects as parent object' do
          expect{ @non_PCDM_object.related_objects << @object101 }.to raise_error(NoMethodError)
        end

        it 'should NOT accept AF::Base objects as parent object' do
          expect{ @af_base_object.related_objects << @object101 }.to raise_error(NoMethodError)
        end

        it 'should NOT accept Hydra::PCDM::Files as parent object' do
          expect{ @file101.related_objects }.to raise_error(NoMethodError)
        end

        it 'should NOT accept non-PCDM objects as parent object' do
          expect{ @non_PCDM_object.related_objects }.to raise_error(NoMethodError)
        end

        it 'should NOT accept AF::Base objects as parent object' do
          expect{ @af_base_object.related_objects }.to raise_error(NoMethodError)
        end
      end
    end
  end

  describe "removing related objects" do
    subject { Hydra::PCDM::Object.new }

    let(:object1) { Hydra::PCDM::Object.new }
    let(:object2) { Hydra::PCDM::Object.new }
    let(:object3) { Hydra::PCDM::Object.new }
    let(:object4) { Hydra::PCDM::Object.new }
    let(:object5) { Hydra::PCDM::Object.new }

    let(:file1) { Hydra::PCDM::File.new }
    let(:file2) { Hydra::PCDM::File.new }

    context 'when it is the only related object' do
      before do
        subject.related_objects << object1
        expect( subject.related_objects ).to eq [object1]
      end

      it 'should remove related object while changes are in memory' do
        expect( subject.related_objects.delete object1 ).to eq [object1]
        expect( subject.related_objects ).to eq []
      end
    end

    context 'when multiple related objects' do
      before do
        subject.related_objects << object1
        subject.related_objects << object2
        subject.related_objects << object3
        subject.related_objects << object4
        subject.related_objects << object5
        expect( subject.related_objects ).to eq [object1,object2,object3,object4,object5]
      end

      it 'should remove first related object when changes are in memory' do
        expect( subject.related_objects.delete object1 ).to eq [object1]
        expect( subject.related_objects ).to eq [object2,object3,object4,object5]
      end

      it 'should remove last related object when changes are in memory' do
        expect( subject.related_objects.delete object5 ).to eq [object5]
        expect( subject.related_objects ).to eq [object1,object2,object3,object4]
      end

      it 'should remove middle related object when changes are in memory' do
        expect( subject.related_objects.delete object3 ).to eq [object3]
        expect( subject.related_objects ).to eq [object1,object2,object4,object5]
      end

      it 'should remove middle related object when changes are saved' do
        expect( subject.related_objects ).to eq [object1,object2,object3,object4,object5]
        expect( subject.related_objects.delete object3 ).to eq [object3]
        subject.save
        expect( subject.reload.related_objects ).to eq [object1,object2,object4,object5]
      end
    end

    context 'when related object is missing' do
      it 'should return empty array when 0 related objects and 0 objects' do
        expect( subject.related_objects.delete object1 ).to eq []
      end

      it 'should return empty array when other related objects and changes in memory' do
        subject.related_objects << object1
        subject.related_objects << object2
        subject.related_objects << object4
        subject.related_objects << object5
        expect( subject.related_objects.delete object3 ).to eq []
      end

      it 'should return empty array when other related objects and changes are in memory' do
        subject.related_objects << object1
        subject.related_objects << object2
        subject.related_objects << object4
        subject.related_objects << object5
        expect( subject.related_objects.delete object3 ).to eq []
      end

      it 'should return empty array when changes are saved' do
        subject.related_objects << object1
        subject.related_objects << object2
        subject.related_objects << object4
        subject.related_objects << object5
        subject.save
        expect( subject.reload.related_objects.delete object3 ).to eq []
      end
    end
  end

  describe "removing child objects" do
    subject { Hydra::PCDM::Object.new }
    let(:object1) { Hydra::PCDM::Object.new }
    let(:object2) { Hydra::PCDM::Object.new }
    let(:object3) { Hydra::PCDM::Object.new }

    context 'when it is the only object' do
      before do
        subject.child_objects += [object1]
        expect( subject.child_objects ).to eq [object1]
      end

      it 'should remove object while changes are in memory' do
        expect( subject.child_objects.delete object1 ).to eq [object1]
        expect( subject.child_objects ).to eq []
      end
    end

    context 'when multiple objects' do
      before do
        subject.child_objects += [object1, object2, object3]
        expect( subject.child_objects ).to eq [object1,object2,object3]
      end

      it 'should remove first object when changes are in memory' do
        expect( subject.child_objects.delete object1 ).to eq [object1]
        expect( subject.child_objects ).to eq [object2,object3]
      end

      it 'should remove last object when changes are in memory' do
        expect( subject.child_objects.delete object3 ).to eq [object3]
        expect( subject.child_objects ).to eq [object1,object2]
      end

      it 'should remove middle object when changes are in memory' do
        expect( subject.child_objects.delete object2 ).to eq [object2]
        expect( subject.child_objects ).to eq [object1,object3]
      end

      it 'should remove middle object when changes are saved' do
        subject.save
        expect( subject.child_objects ).to eq [object1,object2,object3]
        expect( subject.child_objects.delete object2 ).to eq [object2]
        expect( subject.child_objects ).to eq [object1,object3]
      end
    end
    context 'when object repeats' do
      before do
        subject.child_objects += [object1, object2, object3, object2, object3]
        expect( subject.child_objects ).to eq [object1,object2,object3,object2,object3]
      end

      it 'should remove first occurrence when changes in memory' do
        expect( subject.child_objects.delete object2 ).to eq [object2]
        expect( subject.child_objects ).to eq [object1,object3,object3]
      end

      it 'should remove last occurrence when changes in memory' do
      skip( "pending resolution of AF-agg 46 and PCDM 102") do
        expect( subject.child_objects.delete object2, -1 ).to eq object2
        expect( subject.child_objects ).to eq [object1,object2,object3,object3]
      end
      end

      it 'should remove nth occurrence when changes in memory' do
      skip( "pending resolution of AF-agg 46 and PCDM 102") do
        expect( subject.child_objects.delete object2, 2 ).to eq object2
        expect( subject.child_objects ).to eq [object1,object2,object3,object3]
      end
      end

      it 'should remove nth occurrence when changes are saved' do
      skip( "pending resolution of AF-agg 46 and PCDM 102") do
        expect( subject.child_objects ).to eq [object1,object2,object3,object2,object3]
        expect( subject.child_objects ).to eq [object1,object2,object3,object2,object3]

        expect( subject.child_objects.delete object2, 2 ).to eq object2
        subject.save
        expect( subject.child_objects ).to eq [object1,object2,object3,object2,object3]
      end
      end
    end

    context 'when object is missing' do
      it 'and 0 objects in object should return empty array' do
        expect( subject.child_objects.delete object1 ).to eq []
      end

      it 'and multiple objects in object should return empty array when changes are in memory' do
        subject.child_objects += [object1, object2]
        expect( subject.child_objects.delete object3 ).to eq []
      end

      it 'should return empty array when changes are saved' do
        subject.child_objects += [object1, object2]
        expect( subject.child_objects.delete object3 ).to eq []
      end
    end
  end

  describe '#files' do
    subject { described_class.new }
    it "should have a files relation" do
      reflection = subject.reflections[:files]
      expect(reflection.macro).to eq :directly_contains
      expect(reflection.options[:has_member_relation]).to eq RDFVocabularies::PCDMTerms.hasFile
      expect(reflection.options[:class_name].to_s).to eq "Hydra::PCDM::File"
    end
  end

  describe "filtering files" do
    let(:object) { described_class.create }
    let(:thumbnail)   do
      file = object.files.build
      Hydra::PCDM::AddTypeToFile.call(file, pcdm_thumbnail_uri)
    end

    let(:file)                { object.files.build }
    let(:pcdm_thumbnail_uri)  { ::RDF::URI("http://pcdm.org/ThumbnailImage") }

    before do
      file
    end

    describe "filter_files_by_type" do
      context "when the object has files with that type" do
        before do
          thumbnail
        end
        it "allows you to filter the contained files by type URI" do
          expect( object.filter_files_by_type(pcdm_thumbnail_uri) ).to eq [thumbnail]
        end
        it "only overrides the #files method when you specify :type" do
          expect( object.files ).to eq [file, thumbnail]
        end
      end
      context "when the object does NOT have any files with that type" do
        it "returns an empty array" do
          expect( object.filter_files_by_type(pcdm_thumbnail_uri) ).to eq []
        end
      end
    end

    describe "file_of_type" do
      context "when the object has files with that type" do
        before do
          thumbnail
        end
        it "returns the first file with the requested type" do
          expect( object.file_of_type(pcdm_thumbnail_uri) ).to eq thumbnail
        end
      end
      context "when the object does NOT have any files with that type" do
        it "initializes a contained file with the requested type" do
          returned_file =  object.file_of_type(pcdm_thumbnail_uri)
          expect(object.files).to include(returned_file)
          expect(returned_file).to be_new_record
          expect(returned_file.metadata_node.get_values(:type)).to include(pcdm_thumbnail_uri)
        end
      end
    end
  end

  describe ".indexer" do
    after do
      Object.send(:remove_const, :Foo)
    end

    context "without overriding" do
      before do
        class Foo < ActiveFedora::Base
          include Hydra::PCDM::ObjectBehavior
        end
      end

      subject { Foo.indexer }
      it { is_expected.to eq Hydra::PCDM::ObjectIndexer }
    end

    context "when overridden with AS::Concern" do
      before do
        module IndexingStuff
          extend ActiveSupport::Concern

          class AltIndexer; end

          module ClassMethods
            def indexer
              AltIndexer
            end
          end
        end

        class Foo < ActiveFedora::Base
          include Hydra::PCDM::ObjectBehavior
          include IndexingStuff
        end
      end

      subject { Foo.indexer }
      it { is_expected.to eq IndexingStuff::AltIndexer }
    end
  end

end
