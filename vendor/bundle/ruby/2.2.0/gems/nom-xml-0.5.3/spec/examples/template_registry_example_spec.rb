require 'spec_helper'

describe "Template Registry example" do
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

  subject {
    xml.define_template :a do |xml, value|
      xml.a { xml.text value }
    end

    xml.set_terminology do |t|
      t.a
      t.b :template => :asdf
      t.b_ref :path => 'b'

      t.c do |c|
        c.nested
      end
    end

    xml.nom!

    xml
  }

  it "should work" do
    subject.root.add_child(subject.template(:a, 'asdf'))
    expect(subject.a.size).to eq(2)
  end
end
