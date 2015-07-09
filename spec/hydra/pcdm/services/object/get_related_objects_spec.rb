require 'spec_helper'

describe Hydra::PCDM::GetRelatedObjectsFromObject do

  subject { Hydra::PCDM::Object.create }

  let(:object1) { Hydra::PCDM::Object.create }
  let(:object2) { Hydra::PCDM::Object.create }

  describe '#call' do
    it 'should return empty array when no related object' do
      subject.save
      expect(Hydra::PCDM::GetRelatedObjectsFromObject.call( subject )).to eq []
    end


    context 'with files and objects' do
      let(:file1) { subject.files.build }
      let(:file2) { subject.files.build }

      before do
        file1.content = "I'm a file"
        file2.content = "I am too"
        subject.objects += [object1, object2]
        subject.save!
      end

      it 'should return empty array when only files and object are aggregated' do
        expect(Hydra::PCDM::GetRelatedObjectsFromObject.call( subject )).to eq []
      end

      it 'should only return related objects' do
        Hydra::PCDM::AddRelatedObjectToObject.call( subject, object2 )
        expect(Hydra::PCDM::GetRelatedObjectsFromObject.call( subject )).to eq [object2]
      end
   end
  end
end
