require 'spec_helper'

describe "Namespaces example" do
  let(:file) { File.open(File.join(File.dirname(__FILE__), '..', 'fixtures', 'xml_namespaces.xml'), 'r') }
  let(:xml) { Nokogiri::XML(file) }

  subject {
     xml.set_terminology(:namespaces => { 'html4' => 'http://www.w3.org/TR/html4/', 'furniture' => "http://www.w3schools.com/furniture"}) do |t|
       t.table :xmlns => 'html4' do |tb|
         tb.tr do |tr|
           tr.td
         end
       end

       t.furniture_table :path => 'table', :xmlns => 'furniture' do |f|
         f._name :path => 'name'
         f.width
         f.length
       end
     end

     xml.nom!

     xml
  }

  it "should get nodes" do
    expect(subject.table.tr.td.map { |x| x.text }).to include("Apples", "Bananas")
  end

  it "should get nodes from the other namespace" do
    expect(subject.furniture_table._name.text).to include("African Coffee Table")
  end
end
