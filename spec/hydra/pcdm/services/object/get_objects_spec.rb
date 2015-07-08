require 'spec_helper'

describe Hydra::PCDM::GetObjectsFromObject do

  subject { Hydra::PCDM::Object.create }

  let(:object1) { Hydra::PCDM::Object.create }
  let(:object2) { Hydra::PCDM::Object.create }

  describe '#call' do
    it 'should return empty array when no members' do
      subject.save
      expect(Hydra::PCDM::GetObjectsFromObject.call( subject )).to eq []
    end

    context 'with files and objects' do
      let(:file1) { subject.files.build }
      let(:file2) { subject.files.build }

      before do
        file1.content = "I'm a file"
        file2.content = "I am too"
        subject.objects += [object1]
        subject.objects += [object2]
        subject.save!
      end

      it 'should only return objects' do
        expect(Hydra::PCDM::GetObjectsFromObject.call( subject )).to eq [object1,object2]
      end
   end
  end
end
