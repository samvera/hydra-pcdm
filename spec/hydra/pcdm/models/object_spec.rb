require 'spec_helper'

describe Hydra::PCDM::Object do

  let(:object1) { Hydra::PCDM::Object.create }
  let(:object2) { Hydra::PCDM::Object.create }
  let(:object3) { Hydra::PCDM::Object.create }

  describe '#objects=' do
    it 'should aggregate objects' do
      object1.objects = [object2, object3]
      object1.save
      expect(object1.objects).to eq [object2, object3]
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
