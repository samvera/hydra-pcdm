require 'spec_helper'

RSpec.describe Hydra::PCDM::DeepMemberIterator do
  subject { described_class.new(record) }
  let(:record) { instance_double(Hydra::PCDM::Object, members: members) }
  let(:members) { [] }
  describe '#each' do
    context 'with no members' do
      it 'returns an empty array' do
        expect(subject.to_a).to eq []
      end
    end
    context 'with a member' do
      let(:members) { [instance_double(Hydra::PCDM::Object, members: [])] }
      it 'returns that member' do
        expect(subject.to_a).to eq members
      end
    end
    context 'with deep members' do
      let(:member_1) { instance_double(Hydra::PCDM::Object, members: [member_3]) }
      let(:member_2) { instance_double(Hydra::PCDM::Object, members: [member_4]) }
      let(:member_3) { instance_double(Hydra::PCDM::Object, members: []) }
      let(:member_4) { instance_double(Hydra::PCDM::Object, members: []) }
      let(:members)  { [member_1, member_2] }
      it 'does a breadth first iteration of members' do
        expect(subject.to_a).to eq [member_1, member_2, member_3, member_4]
      end
    end
    context 'with n levels deep' do
      let(:member_1) { instance_double(Hydra::PCDM::Object, members: [member_2]) }
      let(:member_2) { instance_double(Hydra::PCDM::Object, members: [member_3]) }
      let(:member_3) { instance_double(Hydra::PCDM::Object, members: []) }
      let(:members)  { [member_1] }
      it 'traverses it' do
        expect(subject.to_a).to eq [member_1, member_2, member_3]
      end
    end
  end
  describe '.include?' do
    context 'with n levels deep' do
      let(:member_1) { instance_double(Hydra::PCDM::Object, members: [member_2]) }
      let(:member_2) { instance_double(Hydra::PCDM::Object, members: [member_3]) }
      let(:member_3) { instance_double(Hydra::PCDM::Object, members: []) }
      let(:members)  { [member_1] }
      it 'does not go any deeper than necessary' do
        expect(subject).to include(member_2)
        expect(member_2).not_to have_received(:members)
        expect(member_3).not_to have_received(:members)
      end
    end
  end
end
