require 'spec_helper'

describe Hydra::PCDM::RemoveRelatedObjectFromObject do

  subject { Hydra::PCDM::Object.new }

  let(:object1) { Hydra::PCDM::Object.new }
  let(:object2) { Hydra::PCDM::Object.new }
  let(:object3) { Hydra::PCDM::Object.new }
  let(:object4) { Hydra::PCDM::Object.new }
  let(:object5) { Hydra::PCDM::Object.new }

  let(:file1) { Hydra::PCDM::File.new }
  let(:file2) { Hydra::PCDM::File.new }

  describe '#call' do
    context 'when it is the only related object' do
      before do
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object1 )
        expect( Hydra::PCDM::GetRelatedObjectsFromObject.call( subject )).to eq [object1]
      end

      it 'should remove related object while changes are in memory' do
        expect( Hydra::PCDM::RemoveRelatedObjectFromObject.call( subject, object1 ) ).to eq object1
        expect( Hydra::PCDM::GetRelatedObjectsFromObject.call( subject )).to eq []
      end
    end

    context 'when multiple related objects' do
      before do
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object1 )
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object2 )
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object3 )
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object4 )
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object5 )
        expect( Hydra::PCDM::GetRelatedObjectsFromObject.call( subject )).to eq [object1,object2,object3,object4,object5]
      end

      it 'should remove first related object when changes are in memory' do
        expect( Hydra::PCDM::RemoveRelatedObjectFromObject.call( subject, object1 ) ).to eq object1
        expect( Hydra::PCDM::GetRelatedObjectsFromObject.call( subject )).to eq [object2,object3,object4,object5]
      end

      it 'should remove last related object when changes are in memory' do
        expect( Hydra::PCDM::RemoveRelatedObjectFromObject.call( subject, object5 ) ).to eq object5
        expect( Hydra::PCDM::GetRelatedObjectsFromObject.call( subject )).to eq [object1,object2,object3,object4]
      end

      it 'should remove middle related object when changes are in memory' do
        expect( Hydra::PCDM::RemoveRelatedObjectFromObject.call( subject, object3 ) ).to eq object3
        expect( Hydra::PCDM::GetRelatedObjectsFromObject.call( subject )).to eq [object1,object2,object4,object5]
      end

      it 'should remove middle related object when changes are saved' do
        subject.save
        expect( Hydra::PCDM::GetRelatedObjectsFromObject.call( subject.reload )).to eq [object1,object2,object3,object4,object5]
        expect( Hydra::PCDM::RemoveRelatedObjectFromObject.call( subject, object3 ) ).to eq object3
        subject.save
        expect( Hydra::PCDM::GetRelatedObjectsFromObject.call( subject.reload )).to eq [object1,object2,object4,object5]
      end
    end

    context 'when related object is missing' do
      it 'should return empty array when 0 related objects and 0 objects' do
      skip( "pending resolution of AF 864") do
        expect( Hydra::PCDM::RemoveRelatedObjectFromObject.call( subject, object1 )).to eq []
      end
      end

      it 'should return empty array when other related objects and changes in memory' do
      skip( "pending resolution of AF 864") do
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object1 )
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object2 )
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object4 )
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object5 )
        expect( Hydra::PCDM::RemoveRelatedObjectFromObject.call( subject, object3 )).to eq []
      end
      end

      it 'should return empty array when other related objects and changes are in memory' do
      skip( "pending resolution of AF 864") do
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object1 )
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object2 )
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object4 )
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object5 )
        expect( Hydra::PCDM::RemoveRelatedObjectFromObject.call( subject, object3 )).to eq []
      end
      end

      it 'should return empty array when changes are saved' do
      skip( "pending resolution of AF 864") do
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object1 )
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object2 )
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object4 )
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object5 )
        subject.save
        expect( Hydra::PCDM::RemoveRelatedObjectFromObject.call( subject.reload, object3 ) ).to eq []
      end
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

    context 'that are unacceptable child objects' do
      let(:error_message) { 'child_related_object must be a pcdm object' }

      it 'should NOT remove Hydra::PCDM::Collections from objects aggregation' do
        expect{ Hydra::PCDM::RemoveRelatedObjectFromObject.call( @object101, @collection101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT remove Hydra::PCDM::Files from objects aggregation' do
        expect{ Hydra::PCDM::RemoveRelatedObjectFromObject.call( @object101, @file101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT remove non-PCDM objects from objects aggregation' do
        expect{ Hydra::PCDM::RemoveRelatedObjectFromObject.call( @object101, @non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT remove AF::Base objects from objects aggregation' do
        expect{ Hydra::PCDM::RemoveRelatedObjectFromObject.call( @object101, @af_base_object ) }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'that are unacceptable parent objects' do
      let(:error_message) { 'parent_object must be a pcdm object' }

      it 'should NOT accept Hydra::PCDM::Collections as parent object' do
        expect{ Hydra::PCDM::RemoveRelatedObjectFromObject.call( @collection101, @object101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Files as parent object' do
        expect{ Hydra::PCDM::RemoveRelatedObjectFromObject.call( @file101, @object101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept non-PCDM objects as parent object' do
        expect{ Hydra::PCDM::RemoveRelatedObjectFromObject.call( @non_PCDM_object, @object101 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept AF::Base objects as parent object' do
        expect{ Hydra::PCDM::RemoveRelatedObjectFromObject.call( @af_base_object, @object101 ) }.to raise_error(ArgumentError,error_message)
      end
    end
  end
end
