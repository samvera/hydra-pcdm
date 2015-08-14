require 'spec_helper'

describe "Nutrition" do
  let(:file) {
    <<-eoxml
  <root>
    <a>1234</a>

    <b>asdf</b>

    <c>
      <nested>poiuyt</nested>
    </c>
  </root>
   eoxml
  }
  let(:xml) { Nokogiri::XML(file) }

  let(:document) {
     xml.set_terminology do |t|
       t.a
       t.b
       t.b_ref :path => 'b'

       t.c do |c|
         c.nested
       end

     end

     xml.nom!
     xml
  }

  describe "#add_terminology_method_overrides!" do

    it "should warn you if you try to override already existing methods" do
      pending if defined? JRUBY_VERSION
      mock_term = {:text => double(:options => {})}
      allow(document.a.first).to receive(:term_accessors).and_return mock_term
      expect { document.a.first.add_terminology_method_overrides! }.to raise_error /Trying to redefine/
    end
  
    it "should let you override the warning" do
      pending if defined? JRUBY_VERSION
      mock_term = {:text => double(:options => { :override => true } )}
      allow(document.a.first).to receive(:term_accessors).and_return mock_term
      expect { document.a.first.add_terminology_method_overrides! }.to_not raise_error
    end
  end

  describe "#terms" do

    context "root element" do
      subject { document.root }

      it "should not have any associated terminology terms" do
        expect(subject.terms).to be_empty
      end
    end

    context "node with a single term" do
      subject { document.xpath('//a').first }

      it "should have a single term" do
        expect(subject.terms.size).to eq(1)
      end

      it "should find the right term" do
        expect(subject.terms.map { |x| x.name }).to include(:a)
      end
    end

    context "node with multiple terms" do
      subject { document.xpath('//b').first }

      it "should have multiple terms" do
        expect(subject.terms.size).to eq(2)
      end

      it "should find the right terms" do
        expect(subject.terms.map { |x| x.name }).to include(:b, :b_ref)
      end
    end
  end

  describe "#term_accessors" do

    context "node" do
      subject { document.xpath('//c').first }

      it "should have a child accessor" do
        expect(subject.send(:term_accessors).keys).to include(:nested)
      end
    end

    context "document" do
      subject { document }

      it "should have all the root terms" do
        expect(subject.send(:term_accessors).keys).to include(:a, :b, :c)
      end
    end

   context "root node" do
      subject { document.root }

      it "should have all the root terms" do
        expect(subject.send(:term_accessors).keys).to include(:a, :b, :c)
      end
    end
  end

end

