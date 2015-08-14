require 'spec_helper'

describe Nom::XML::Decorators::NodeSet do
  subject {
    doc = Nokogiri::XML '<root><a n="1"/><b /><c /></root>'
    doc.nom!
    doc
  }
  describe "#values_for_term" do

    it "should do if" do
      t  = double(:options => { :if => lambda { |x| false }})
      t1 = double(:options => { :if => lambda { |x| true }})

      expect(subject.xpath('//*').values_for_term(t)).to be_empty
      expect(subject.xpath('//*').values_for_term(t1)).not_to be_empty
    end

    it "should do unless" do
      t  = double(:options => { :unless => lambda { |x| false }})
      t1 = double(:options => { :unless => lambda { |x| true }})

      expect(subject.xpath('//*').values_for_term(t)).not_to be_empty
      expect(subject.xpath('//*').values_for_term(t1)).to be_empty
    end

    it "should do a nil accessor" do
      t = double(:options => { :accessor => nil})
      expect(subject.xpath('//*').values_for_term(t)).to eq(subject.xpath('//*'))
    end

    it "should do a Proc accessor" do
      t = double(:options => { :accessor => lambda { |x| 1 }})
      expect(subject.xpath('//a').values_for_term(t)).to eq([1])
    end

    it "should do a symbol accessor" do
      t = double(:options => { :accessor => :z })
      allow(subject.xpath('//a').first).to receive(:z).and_return(1)
      expect(subject.xpath('//a').values_for_term(t)).to eq([1])
    end

    it "should do single" do
      t = double(:options => { :single => true})
      expect(subject.xpath('//*').values_for_term(t)).to eq(subject.xpath('//*').first)
    end

    it "should treat an attribute as a single" do
      t = double(:options => { })
      expect(subject.xpath('//@n').values_for_term(t)).to be_a_kind_of Nokogiri::XML::Attr
    end
  end

  describe "method missing and respond to" do
    it "should respond to methods on nodes if all nodes in the nodeset respond to the method" do
      expect(subject.xpath('//*')).to respond_to :text
      expect(subject.xpath('//*').respond_to?(:text, true)).to be_truthy
      expect(subject.xpath('//*').respond_to?(:text, false)).to be_truthy
    end

    it "should respond to methods on nodes if all nodes in the nodeset respond to the method" do
      expect(subject.xpath('//*')).not_to respond_to :text_123
    end

    it "should work" do
      expect(subject.xpath('//*').name).to include("a", "b", "c")
    end
  end
end
