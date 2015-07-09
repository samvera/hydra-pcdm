require 'spec_helper'

RSpec.describe Hydra::PCDM::Validators::MembersAreObjects do
  subject { described_class.new }
  let(:record) do
    instance_double(Hydra::PCDM::Object, :members => members, :errors => errors)
  end
  let(:members) { [member] }
  let(:member) { ActiveFedora::Base.new }
  let(:errors) { double("errors", :add => nil) }
  describe "#validate" do
    def validate
      subject.validate(record)
    end
    context "when given no members" do
      let(:members) { [] }
      it "should be valid" do
        validate

        expect(errors).not_to have_received(:add)
      end
    end
    context "when given a non-pcdm object" do
      it "should be invalid" do
        validate

        expect(errors).to have_received(:add)
      end
    end
    context "when given a PCDM object" do
      let(:member) { Hydra::PCDM::Object.new }
      it "should be valid" do
        validate

        expect(errors).not_to have_received(:add)
      end
    end
    context "when given a PCDM collection" do
      let(:member) { Hydra::PCDM::Collection.new }
      it "should be valid" do
        validate

        expect(errors).not_to have_received(:add)
      end
    end
  end
end
