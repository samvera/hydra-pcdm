require 'spec_helper'

describe Nom::XML::Terminology do
  describe "#namespaces" do
    it "should pull the namespaces out of the terminology options" do
      expect(Nom::XML::Terminology.new(nil, :namespaces => { 'asd' => '123'}).namespaces).to eq({ 'asd' => '123'})
    end

    it "should return an empty hash if no namespace is provided" do
      expect(Nom::XML::Terminology.new.namespaces).to eq({})
    end
  end

  describe "#terminology" do
    it "should be an identity function" do
      a = Nom::XML::Terminology.new

      expect(a.terminology).to eq(a)
    end
  end
end