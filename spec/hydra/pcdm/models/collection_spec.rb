require 'spec_helper'

describe Hydra::PCDM::Collection do

  let(:collection1) { Hydra::PCDM::Collection.new }
  let(:collection2) { Hydra::PCDM::Collection.new }
  let(:collection3) { Hydra::PCDM::Collection.new }

  let(:object1) { Hydra::PCDM::Object.new }
  let(:object2) { Hydra::PCDM::Object.new }

  describe "adding collections" do
    describe "with acceptable inputs" do
      subject { Hydra::PCDM::Collection.new }
      it 'should add collections, sub-collections, and repeating collections' do
        subject.child_collections << collection1      # first add
        subject.child_collections << collection2      # second add to same collection
        subject.child_collections << collection1      # repeat a collection
        collection1.child_collections << collection3  # add sub-collection
        expect( subject.child_collections ).to eq [collection1,collection2,collection1]
        expect( collection1.child_collections ).to eq [collection3]
      end
      it 'should add an object to collection with collections and objects' do
        subject.members << collection1
        subject.members << collection2
        subject.members << object1
        subject.members << object2
        subject.members << collection3
        expect( subject.members ).to eq [collection1,collection2,object1,object2,collection3]
        expect( subject.child_collections ).to eq [collection1,collection2,collection3]
        expect( subject.child_objects ).to eq [object1,object2]
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
        subject.child_collections << kollection1
        expect( subject.child_collections ).to eq [kollection1]
      end
  
      it 'should accept implementing collection as a parent' do
        kollection1.child_collections << collection1
        expect( kollection1.child_collections ).to eq [collection1]
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
        subject.child_collections << cullection1
        expect( subject.child_collections ).to eq [cullection1]
      end
  
      it 'should accept extending collection as a parent' do
        cullection1.child_collections << collection1
        expect( cullection1.child_collections ).to eq [collection1]
      end
    end

    describe 'with unacceptable input types' do
      before(:all) do
        @object101       = Hydra::PCDM::Object.new
        @file101         = Hydra::PCDM::File.new
        @non_PCDM_object = "I'm not a PCDM object"
        @af_base_object  = ActiveFedora::Base.new
      end
  
      context 'that are unacceptable child collections' do
        let(:error_type1)    { ArgumentError }
        let(:error_message1) { 'Hydra::PCDM::Object with ID:  was expected to pcdm_collection?, but it was false' }
        let(:error_type2)    { NoMethodError }
        let(:error_message2) { /undefined method `pcdm_collection\?' for .*/ }
  
        it 'should NOT aggregate Hydra::PCDM::Objects in collections aggregation' do
          expect{ collection1.child_collections << @object101 }.to raise_error(error_type1,error_message1)
        end
  
        it 'should NOT aggregate Hydra::PCDM::Files in collections aggregation' do
          expect{ collection1.child_collections << @file101 }.to raise_error(error_type2,error_message2)
        end
  
        it 'should NOT aggregate non-PCDM objects in collections aggregation' do
          expect{ collection1.child_collections << @non_PCDM_object }.to raise_error(error_type2,error_message2)
        end
  
        it 'should NOT aggregate AF::Base objects in collections aggregation' do
          expect{ collection1.child_collections << @af_base_object }.to raise_error(error_type2,error_message2)
        end
      end
    end

    describe "adding collections that are ancestors" do
      let(:error_type)    { ArgumentError }
      let(:error_message) { 'Hydra::PCDM::Collection with ID:  failed to pass AncestorChecker validation' }
  
      context "when the source collection is the same" do
        it "raises an error" do
          expect{ subject.child_collections << subject }.to raise_error(error_type, error_message)
        end
      end
  
      before do
        subject.child_collections << collection1
      end
  
      it "raises and error" do
        expect{ collection1.child_collections << subject }.to raise_error(error_type, error_message)
      end
  
      context "with more ancestors" do
        before do
          collection1.child_collections << collection2
        end
  
        it "raises an error" do
          expect{ collection2.child_collections << subject }.to raise_error(error_type, error_message)
        end
  
        context "with a more complicated example" do
          before do
            collection2.child_collections << collection3
          end
  
          it "raises errors" do
            expect{ collection3.child_collections << subject }.to raise_error(error_type, error_message)
            expect{ collection3.child_collections << collection1 }.to raise_error(error_type, error_message)
          end
        end
      end
    end
  end

  describe "removing collections" do
    subject { Hydra::PCDM::Collection.new }

    context 'when it is the only collection' do

      before do
        subject.members << collection1
        expect( subject.child_collections ).to eq [collection1]
      end

      it 'should remove collection while changes are in memory' do
        expect( subject.members.delete collection1 ).to eq [collection1]
        expect( subject.child_collections ).to eq []
      end

      it 'should remove collection only when objects and all changes are in memory' do
        subject.members << object1
        subject.members << object2
        expect( subject.members.delete collection1 ).to eq [collection1]
        expect( subject.child_collections ).to eq []
        expect( subject.child_objects ).to eq [object1,object2]
      end
    end

    context 'when multiple collections' do
      before do
        subject.members << collection1
        subject.members << collection2
        subject.members << collection3
        expect( subject.child_collections ).to eq [collection1,collection2,collection3]
      end

      it 'should remove first collection when changes are in memory' do
        expect( subject.members.delete collection1 ).to eq [collection1]
        expect( subject.child_collections ).to eq [collection2,collection3]
      end

      it 'should remove last collection when changes are in memory' do
        expect( subject.members.delete collection3 ).to eq [collection3]
        expect( subject.child_collections ).to eq [collection1,collection2]
      end

      it 'should remove middle collection when changes are in memory' do
        expect( subject.members.delete collection2 ).to eq [collection2]
        expect( subject.child_collections ).to eq [collection1,collection3]
      end

      it 'should remove middle collection when changes are saved' do
        expect( subject.child_collections ).to eq [collection1,collection2,collection3]
        subject.save
        expect( subject.members.delete collection2 ).to eq [collection2]
        expect( subject.child_collections ).to eq [collection1,collection3]
      end
    end
    context 'when collection is missing' do
      it 'and 0 sub-collections should return empty array' do
      skip( "pending resolution of AF-agg 55 and AF 864") do
        expect( subject.members.remove collection1 ).to eq []
      end
      end

      it 'and multiple sub-collections should return empty array when changes are in memory' do
      skip( "pending resolution of AF-agg 55 and AF 864") do
        subject.members << collection1
        subject.members << collection3
        expect( subject.members.remove collection2 ).to eq []
      end
      end

      it 'should return empty array when changes are saved' do
      skip( "pending resolution of AF-agg 55 and AF 864") do
        subject.members << collection1
        subject.members << collection3
        subject.save
        expect( subject.members.remove collection2 ).to eq []
      end
      end
    end
  end

  describe "adding objects" do
    context 'with acceptable inputs' do
      it 'should add objects, sub-collections, and repeating collections' do
        subject.child_objects << object1      # first add
        subject.child_objects << object2      # second add to same collection
        subject.child_objects << object1      # repeat an object
        expect( subject.child_objects ).to eq [object1,object2,object1]
      end

      context 'with collections and objects' do
        it 'should add an object to collection with collections and objects' do
          subject.child_objects << object1
          subject.child_collections << collection1
          subject.child_collections << collection2
          subject.child_objects << object2
          expect( subject.child_objects ).to eq [object1,object2]
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
          subject.child_objects << ahbject1
          expect( subject.child_objects ).to eq [ahbject1]
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
          subject.child_objects << awbject1
          expect( subject.child_objects ).to eq [awbject1]
        end
      end
    end

    context 'with unacceptable inputs' do
      before(:all) do
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
          expect{ collection1.child_objects << collection2 }.to raise_error(error_type1,error_message1)
        end

        it 'should NOT aggregate Hydra::PCDM::Files in objects aggregation' do
          expect{ collection1.child_objects << @file101 }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate non-PCDM objects in objects aggregation' do
          expect{ collection1.child_objects << @non_PCDM_object }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate AF::Base objects in objects aggregation' do
          expect{ collection1.child_objects << @af_base_object }.to raise_error(error_type2,error_message2)
        end
      end
    end
  end

  describe "removing objects" do
    context 'when it is the only object' do
      before do
        subject.child_objects << object1
        expect( subject.child_objects ).to eq [object1]
      end

      it 'should remove object while changes are in memory' do
        expect( subject.child_objects.delete object1 ).to eq [object1]
        expect( subject.child_objects ).to eq []
      end

      it 'should remove object only when collections and all changes are in memory' do
        subject.child_collections << collection1
        subject.child_collections << collection2
        expect( subject.child_objects.delete object1 ).to eq [object1]
        expect( subject.child_objects ).to eq []
        expect( subject.child_collections ).to eq [collection1,collection2]
      end
    end

    context 'when multiple objects' do
      let(:object3) { Hydra::PCDM::Object.new }

      before do
        subject.child_objects << object1
        subject.child_objects << object2
        subject.child_objects << object3
        expect( subject.child_objects ).to eq [object1,object2,object3]
      end

      it 'should remove first object when changes are in memory' do
        expect( subject.child_objects.delete object1 ).to eq [object1]
        expect( subject.child_objects ).to eq [object2,object3]
      end

      it 'should remove middle object when changes are in memory' do
        expect( subject.child_objects.delete object2 ).to eq [object2]
        expect( subject.child_objects ).to eq [object1,object3]
      end

      it 'should remove last object when changes are in memory' do
        expect( subject.child_objects.delete object3 ).to eq [object3]
        expect( subject.child_objects ).to eq [object1,object2]
      end
      it 'should remove middle object when changes are saved' do
        expect( subject.child_objects.delete object2 ).to eq [object2]
        expect( subject.child_objects ).to eq [object1,object3]
        subject.save
        expect( subject.reload.child_objects ).to eq [object1,object3]
      end
    end

    context 'when object repeats' do
      let(:object3) { Hydra::PCDM::Object.new }
      let(:object4) { Hydra::PCDM::Object.new }
      let(:object5) { Hydra::PCDM::Object.new }

      before do
        subject.child_objects << object1
        subject.child_objects << object2
        subject.child_objects << object3
        subject.child_objects << object2
        subject.child_objects << object4
        subject.child_objects << object2
        subject.child_objects << object5
        expect( subject.child_objects ).to eq [object1,object2,object3,object2,object4,object2,object5]
      end

      # TODO pending implementation of multiple objects

      it 'should remove first occurrence when changes in memory' do
      skip( "pending resolution of AF-agg 46 and PCDM 102") do
        expect( subject.child_objects.delete object2 ).to eq [object2]
        expect( subject.child_objects ).to eq [object1,object3,object2,object4,object2,object5]
      end
      end

      it 'should remove last occurrence when changes in memory' do
      skip( "pending resolution of AF-agg 46 and PCDM 102") do
        expect( subject.child_objects.delete object2, -1 ).to eq object2
        expect( subject.child_objects ).to eq [object1,object2,object3,object2,object4,object5]
      end
      end

      it 'should remove nth occurrence when changes in memory' do
      skip( "pending resolution of AF-agg 46 and PCDM 102") do
        expect( subject.child_objects.delete object2, 2 ).to eq object2
        expect( subject.child_objects ).to eq [object1,object2,object3,object4,object2,object5]
      end
      end
      it 'should remove nth occurrence when changes are saved' do
        skip( "pending resolution of AF-agg 46 and PCDM 102") do
          expect( subject.child_objects ).to eq [object1,object2,object3,object2,object4,object2,object5]
          subject.save
          expect( subject.reload.child_objects ).to eq [object1,object2,object3,object2,object4,object2,object5]

          expect( subject.child_objects.delete object2, 2 ).to eq object2
          subject.save
          expect( subject.reload.child_objects ).to eq [object1,object2,object3,object4,object2,object5]
        end
      end
    end

    context 'when object is missing' do
      it 'and 0 objects in collection should return empty array' do
      skip( "pending resolution of AF-agg 55 and AF 864") do
        expect( subject.child_objects.remove object1 ).to eq []
      end
      end

      it 'and multiple objects in collection should return empty array when changes are in memory' do
      skip( "pending resolution of AF-agg 55 and AF 864") do
        subject.child_objects << object1
        subject.child_objects << object2
        expect( subject.child_objects.delete object3 ).to eq []
      end
      end

      it 'should return empty array when changes are saved' do
      skip( "pending resolution of AF-agg 55 and AF 864") do
        subject.child_objects << object1
        subject.child_objects << object2
        subject.save
        expect( subject.reload.child_objects.delete object3 ).to eq []
      end
      end
    end
  end

  describe "add related objects" do
    context 'with acceptable collections' do

      it 'should add objects to the related object set' do
        collection1.related_objects << object1      # first add
        collection1.related_objects << object2      # second add to same collection
        collection1.save
        related_objects = collection1.reload.related_objects
        expect( related_objects.include? object1 ).to be true
        expect( related_objects.include? object2 ).to be true
        expect( related_objects.size ).to eq 2
      end

      it 'should be empty when no related objects' do
        expect( collection1.related_objects ).to eq []
      end

      it 'should not repeat objects in the related object set' do
        skip 'pending resolution of ActiveFedora issue #853' do
          collection1.related_objects << object1      # first add
          collection1.related_objects << object2      # second add to same collection
          collection1.related_objects << object1      # repeat an object replaces the object
          related_objects = collection1.related_objects
          expect( related_objects.include? object1 ).to be true
          expect( related_objects.include? object2 ).to be true
          expect( related_objects.size ).to eq 2
        end
      end
    end
    context 'with unacceptable inputs' do
      before(:all) do
        @file101         = Hydra::PCDM::File.new
        @non_PCDM_object = "I'm not a PCDM object"
        @af_base_object  = ActiveFedora::Base.new
      end

      context 'with unacceptable related objects' do
        it 'should NOT aggregate Hydra::PCDM::Collection in objects aggregation' do
          skip 'pending resolution of Hydra::PCDM issue #153' do
            expect{ collection2.related_objects << collection1 }.to raise_error(ArgumentError)
          end
        end

        it 'should NOT aggregate Hydra::PCDM::Files in objects aggregation' do
          skip 'pending resolution of Hydra::PCDM issue #153' do
            expect{ collection2.related_objects << @file1 }.to raise_error(ArgumentError)
          end
        end

        it 'should NOT aggregate non-PCDM objects in objects aggregation' do
          skip 'pending resolution of Hydra::PCDM issue #153' do
            expect{ collection2.related_objects << @non_PCDM_object }.to raise_error(ArgumentError)
          end
        end

        it 'should NOT aggregate AF::Base objects in objects aggregation' do
          skip 'pending resolution of Hydra::PCDM issue #153' do
            expect{ collection2.related_objects << @af_base_object }.to raise_error(ArgumentError)
          end
        end
      end

      context 'with unacceptable parent object' do
        it 'should NOT accept Hydra::PCDM::Files as parent object' do
          expect{ @file1.related_objects << object1 }.to raise_error(NoMethodError)
        end

        it 'should NOT accept non-PCDM objects as parent object' do
          expect{ @non_PCDM_object.related_objects << object1 }.to raise_error(NoMethodError)
        end

        it 'should NOT accept AF::Base objects as parent object' do
          expect{ @af_base_object.related_objects << object1 }.to raise_error(NoMethodError)
        end

        it 'Hydra::PCDM::File should NOT have related files' do
          expect{ @file1.related_objects }.to raise_error(NoMethodError)
        end

        it 'Non-PCDM objects should should NOT have related objects' do
          expect{ @non_PCDM_object.related_objects }.to raise_error(NoMethodError)
        end

        it 'AF::Base should NOT have related_objects' do
          expect{ @af_base_object.related_objects }.to raise_error(NoMethodError)
        end
      end
    end
  end

  describe "remove related objects" do
    context 'when it is the only related object' do
      let(:object3) { Hydra::PCDM::Object.new }

      before do
        subject.related_objects << object1
        expect( subject.related_objects ).to eq [object1]
      end

      it 'should remove related object while changes are in memory' do
        expect( subject.related_objects.delete object1 ).to eq [object1]
        expect( subject.related_objects ).to eq []
      end

      it 'should remove related object only when objects & collections and all changes are in memory' do
        subject.child_collections << collection1
        subject.child_collections << collection2
        subject.child_objects << object3
        subject.child_objects << object2
        expect( subject.related_objects.delete object1 ).to eq [object1]
        expect( subject.related_objects ).to eq []
        expect( subject.child_collections ).to eq [collection1,collection2]
        expect( subject.child_objects ).to eq [object3,object2]
      end
    end

    context 'when multiple related objects' do
      let(:object3) { Hydra::PCDM::Object.new }

      before do
        subject.related_objects << object1
        subject.related_objects << object2
        subject.related_objects << object3
        expect( subject.related_objects ).to eq [object1,object2,object3]
      end

      it 'should remove first related object when changes are in memory' do
        expect( subject.related_objects.delete object1 ).to eq [object1]
        expect( subject.related_objects ).to eq [object2,object3]
      end

      it 'should remove last related object when changes are in memory' do
        expect( subject.related_objects.delete object3 ).to eq [object3]
        expect( subject.related_objects ).to eq [object1,object2]
      end

      it 'should remove middle related object when changes are in memory' do
        expect( subject.related_objects.delete object2 ).to eq [object2]
        expect( subject.related_objects ).to eq [object1,object3]
      end

      it 'should remove middle related object when changes are saved' do
        expect( subject.related_objects ).to eq [object1,object2,object3]
        expect( subject.related_objects.delete object2 ).to eq [object2]
        subject.save
        expect( subject.reload.related_objects ).to eq [object1,object3]
      end
    end

    context 'when related object is missing' do
      it 'should return empty array when 0 related objects and 0 collections and objects' do
      skip( "pending resolution of AF 864") do
        expect( subject.related_objects.delete object1 ).to eq []
      end
      end

      it 'should return empty array when 0 related objects, but has collections and objects and changes in memory' do
      skip( "pending resolution of AF 864") do
        subject.members << collection1
        subject.members << collection2
        subject.members << object1
        subject.members << object2
        expect( subject.related_objects.delete object1 ).to eq []
      end
      end

      it 'should return empty array when other related objects and changes are in memory' do
      skip( "pending resolution of AF 864") do
        subject.related_objects << object1
        subject.related_objects << object3
        expect( subject.related_objects.delete object2 ).to eq []
      end
      end

      it 'should return empty array when changes are saved' do
      skip( "pending resolution of AF 864") do
        subject.related_objects << object1
        subject.related_objects << object3
        subject.save
        expect( subject.reload.related_objects.delete object2 ).to eq []
      end
      end
    end
  end

  context 'with unacceptable inputs' do
    before(:all) do
      @file101         = Hydra::PCDM::File.new
      @non_PCDM_object = "I'm not a PCDM object"
      @af_base_object  = ActiveFedora::Base.new
    end
    context 'that are unacceptable child objects' do
      let(:error_message) { 'child_related_object must be a pcdm object' }

      it 'should NOT remove Hydra::PCDM::Collections from objects aggregation' do
        skip 'pending resolution of Hydra::PCDM issue #153' do
          expect{ collection1.related_objects.delete collection2 }.to raise_error(ArgumentError,error_message)
        end
      end

      it 'should NOT remove Hydra::PCDM::Files from objects aggregation' do
        skip 'pending resolution of Hydra::PCDM issue #153' do
          expect{ collection1.related_objects.delete @file101 }.to raise_error(ArgumentError,error_message)
        end
      end

      it 'should NOT remove non-PCDM objects from objects aggregation' do
        skip 'pending resolution of Hydra::PCDM issue #153' do
          expect{ collection1.related_objects.delete @non_PCDM_object }.to raise_error(ArgumentError,error_message)
        end
      end

      it 'should NOT remove AF::Base objects from objects aggregation' do
        skip 'pending resolution of Hydra::PCDM issue #153' do
          expect{ collection1.related_objects.delete @af_base_object }.to raise_error(ArgumentError,error_message)
        end
      end
    end

    context 'that are unacceptable parent collections' do
      it 'should NOT accept Hydra::PCDM::Files as parent collection' do
        expect{ @file101.related_objects.delete object1 }.to raise_error(NoMethodError)
      end

      it 'should NOT accept non-PCDM objects as parent collection' do
        expect{ @non_PCDM_object.related_objects.delete object1 }.to raise_error(NoMethodError)
      end

      it 'should NOT accept AF::Base objects as parent collection' do
        expect{ @af_base_object.related_objects.delete object1 }.to raise_error(NoMethodError)
      end
    end
  end

  describe '#child_collections=' do
    it 'should aggregate collections' do
      collection1.child_collections = [collection2, collection3]
      expect(collection1.child_collections).to eq [collection2, collection3]
    end
  end

  describe '#child_objects=' do
    it 'should aggregate objects' do
      collection1.child_objects = [object1,object2]
      expect(collection1.child_objects).to eq [object1,object2]
    end
  end

  describe "#child_collection_ids" do
    let(:child1) { described_class.new(id: '1') }
    let(:child2) { described_class.new(id: '2') }
    let(:object) { described_class.new }
    before { object.child_collections = [child1, child2] }

    subject { object.child_collection_ids }

    it { is_expected.to eq ["1", "2"] }
  end

  describe 'child_collections and child_objects' do
    subject { Hydra::PCDM::Collection.new }

    it 'should return empty array when no members' do
      expect( subject.child_collections ).to eq []
      expect( subject.child_objects ).to eq []
    end

    it 'child_collections should return empty array when only objects are aggregated' do
      subject.members << object1
      subject.members << object2
      expect( subject.child_collections ).to eq []
    end

    it 'child_objects should return empty array when only collections are aggregated' do
      subject.members << collection1
      subject.members << collection2
      expect( subject.child_objects ).to eq []
    end

    context 'should only contain members of the correct type' do
      it 'should only return collections' do
        subject.child_collections << collection1
        subject.members << collection2
        subject.child_objects << object1
        subject.members << object2
        expect( subject.child_collections ).to eq [collection1,collection2]
        expect( subject.child_objects ).to eq [object1,object2]
        expect( subject.members ).to eq [collection1,collection2,object1,object2]
      end
    end
  end

  context 'when aggregated by other objects' do

    before do
      # Using before(:all) and instance variable because regular :let syntax had a significant impact on performance
      # All of the tests in this context are describing idempotent behavior, so isolation between examples isn't necessary.
      @collection1 = Hydra::PCDM::Collection.new
      @collection2 = Hydra::PCDM::Collection.new
      @collection =  Hydra::PCDM::Collection.new
      @collection1.child_collections << @collection
      @collection2.child_collections << @collection
      allow(@collection).to receive(:id).and_return("banana")
      proxies = [
          build_proxy(container: @collection1),
          build_proxy(container: @collection2),
      ]
      allow(ActiveFedora::Aggregation::Proxy).to receive(:where).with(proxyFor_ssim: @collection.id).and_return(proxies)
    end

    describe 'parents' do
      subject { @collection.parents }
      it "finds all nodes that aggregate the object with hasMember" do
        expect(subject).to include(@collection1, @collection2)
        expect(subject.count).to eq 2
      end
    end

    describe 'parent_collections' do
      subject { @collection.parent_collections }
      it "finds collections that aggregate the object with hasMember" do
        expect(subject).to include(@collection1, @collection2)
        expect(subject.count).to eq 2
      end
    end
    def build_proxy(container:)
      instance_double(ActiveFedora::Aggregation::Proxy, container: container)
    end
  end

  describe ".indexer" do
    after do
      Object.send(:remove_const, :Foo)
    end

    context "without overriding" do
      before do
        class Foo < ActiveFedora::Base
          include Hydra::PCDM::CollectionBehavior
        end
      end

      subject { Foo.indexer }
      it { is_expected.to eq Hydra::PCDM::CollectionIndexer }
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
          include Hydra::PCDM::CollectionBehavior
          include IndexingStuff
        end
      end

      subject { Foo.indexer }
      it { is_expected.to eq IndexingStuff::AltIndexer }
    end
  end
end
