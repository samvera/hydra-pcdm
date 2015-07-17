require 'spec_helper'

describe Hydra::PCDM::RemoveObjectFromObject do

  subject { Hydra::PCDM::Object.new }

  let(:object1) { Hydra::PCDM::Object.new }
  let(:object2) { Hydra::PCDM::Object.new }
  let(:object3) { Hydra::PCDM::Object.new }
  let(:object4) { Hydra::PCDM::Object.new }
  let(:object5) { Hydra::PCDM::Object.new }

  describe '#call' do
    context 'when it is the only object' do
      before do
        subject.child_objects += [object1]
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject )).to eq [object1]
      end

      it 'should remove object while changes are in memory' do
        expect( Hydra::PCDM::RemoveObjectFromObject.call( subject, object1 ) ).to eq object1
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject )).to eq []
      end
    end

    context 'when multiple objects' do
      before do
        subject.child_objects += [object1, object2, object3, object4, object5]
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject )).to eq [object1,object2,object3,object4,object5]
      end

      it 'should remove first object when changes are in memory' do
        expect( Hydra::PCDM::RemoveObjectFromObject.call( subject, object1 ) ).to eq object1
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject )).to eq [object2,object3,object4,object5]
      end

      it 'should remove last object when changes are in memory' do
        expect( Hydra::PCDM::RemoveObjectFromObject.call( subject, object5 ) ).to eq object5
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject )).to eq [object1,object2,object3,object4]
      end

      it 'should remove middle object when changes are in memory' do
        expect( Hydra::PCDM::RemoveObjectFromObject.call( subject, object3 ) ).to eq object3
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject )).to eq [object1,object2,object4,object5]
      end

      it 'should remove middle object when changes are saved' do
        subject.save
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject.reload )).to eq [object1,object2,object3,object4,object5]
        expect( Hydra::PCDM::RemoveObjectFromObject.call( subject, object3 ) ).to eq object3
        subject.save
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject.reload )).to eq [object1,object2,object4,object5]
      end
    end

    context 'when object repeats' do
      before do
        subject.child_objects += [object1, object2, object3, object2, object4, object2, object5]
        expect(Hydra::PCDM::GetObjectsFromObject.call( subject )).to eq [object1,object2,object3,object2,object4,object2,object5]
      end

      it 'should remove first occurrence when changes in memory' do
      skip( "pending resolution of AF-agg 46 and PCDM 102") do
        expect( Hydra::PCDM::RemoveObjectFromObject.call( subject, object2 ) ).to eq object2
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject )).to eq [object1,object3,object2,object4,object2,object5]
      end
      end

      it 'should remove last occurrence when changes in memory' do
      skip( "pending resolution of AF-agg 46 and PCDM 102") do
        expect( Hydra::PCDM::RemoveObjectFromObject.call( subject, object2, -1 ) ).to eq object2
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject )).to eq [object1,object2,object3,object2,object4,object5]
      end
      end

      it 'should remove nth occurrence when changes in memory' do
      skip( "pending resolution of AF-agg 46 and PCDM 102") do
        expect( Hydra::PCDM::RemoveObjectFromObject.call( subject, object2, 2 ) ).to eq object2
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject )).to eq [object1,object2,object3,object4,object2,object5]
      end
      end

      it 'should remove nth occurrence when changes are saved' do
      skip( "pending resolution of AF-agg 46 and PCDM 102") do
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject )).to eq [object1,object2,object3,object2,object4,object2,object5]
        subject.save
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject.reload )).to eq [object1,object2,object3,object2,object4,object2,object5]

        expect( Hydra::PCDM::RemoveObjectFromObject.call( subject, object2, 2 ) ).to eq object2
        subject.save
        expect( Hydra::PCDM::GetObjectsFromObject.call( subject.reload )).to eq [object1,object2,object3,object4,object2,object5]
      end
      end
    end

    context 'when object is missing' do
      it 'and 0 objects in object should return empty array' do
      skip( "pending resolution of AF-agg 55 and AF 864") do
        expect( Hydra::PCDM::RemoveObjectFromObject.call( subject, object1 )).to eq []
      end
      end

      it 'and multiple objects in object should return empty array when changes are in memory' do
      skip( "pending resolution of AF-agg 55 and AF 864") do
        subject.child_objects += [object1, object2, object4, object5]
        expect( Hydra::PCDM::RemoveObjectFromObject.call( subject, object3 )).to eq []
      end
      end

      it 'should return empty array when changes are saved' do
      skip( "pending resolution of AF-agg 55 and AF 864") do
        subject.child_objects += [object1, object2, object4, object5]
        subject.save
        expect( Hydra::PCDM::RemoveObjectFromObject.call( subject.reload, object3 ) ).to eq []
      end
      end
    end
  end
end
