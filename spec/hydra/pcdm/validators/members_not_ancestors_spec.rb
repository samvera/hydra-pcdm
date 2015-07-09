require 'spec_helper'

RSpec.describe Hydra::PCDM::Validators::MembersNotAncestors do
  subject { described_class.new }

  describe "#validate" do
    def validate
      subject.validate(record)
    end
    let(:record) { instance_double(Hydra::PCDM::Object, :errors => errors) }
    let(:errors) { double("errors", :add => nil) }
    let(:members) { [member] }
    let(:member) { record }
    before do
      allow(record).to receive(:members).and_return(members)
    end

    context "when the member is the record itself" do
      it "should not be valid" do
        validate

        expect(errors).to have_received(:add)
      end
    end
    context "when the member is not an ancestor" do
      let(:member) { instance_double(Hydra::PCDM::Object, :members => []) }
      it "should be valid" do
        validate

        expect(errors).not_to have_received(:add)
      end
    end
    context "when the member is an ancestor" do
      let(:member) { instance_double(Hydra::PCDM::Object, :members => [record]) }
      it "should not be valid" do
        validate

        expect(errors).to have_received(:add)
      end
    end
  end
end
