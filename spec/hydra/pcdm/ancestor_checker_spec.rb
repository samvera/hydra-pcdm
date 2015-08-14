require 'spec_helper'

RSpec.describe Hydra::PCDM::AncestorChecker do
  subject { described_class.new(record) }

  describe '#ancestor?' do
    let(:record) { instance_double(Hydra::PCDM::Object) }
    let(:member) { record }
    let(:result) { subject.ancestor?(member) }

    context 'when the member is the record itself' do
      it 'is true' do
        expect(result).to eq true
      end
    end
    context 'when the member is not an ancestor' do
      let(:member) { instance_double(Hydra::PCDM::Object, members: []) }
      it 'is false' do
        expect(result).to eq false
      end
    end
    context 'when the member is an ancestor' do
      let(:member) { instance_double(Hydra::PCDM::Object, members: [record]) }
      it 'is true' do
        expect(result).to eq true
      end
    end
  end
end
