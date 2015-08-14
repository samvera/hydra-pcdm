require 'spec_helper'

describe "Namespaces example" do

  let(:file) { File.read(File.join(File.dirname(__FILE__), '..', 'fixtures', 'mods_document.xml')) }
  let(:xml) { Nokogiri::XML(file) }

  subject {

     xml.set_terminology(:namespaces => { 'mods' => 'http://www.loc.gov/mods/v3'}) do |t|

      t.genre :path => "mods:genre", :accessor => lambda { |e| e.text }

      t.author :path => '//mods:name' do |n|
        n.authorityURI :path => '@authorityURI', :accessor => lambda { |e| e.text }
        n.description :path => 'mods:description', :override => true
        n.valueURI :path => '@valueURI'
        n.namePart :path => 'mods:namePart', :single => true, :index_as => [:type_1]
      end

      t.corporate_authors :path => '//mods:name[@type="corporate"]'
      t.personal_authors :path => 'mods:name[@type="personal"]' do |n|
        n.roleTerm :path => 'mods:role/mods:roleTerm', :index_as => [:type_1] do |r|
          r._type :path => '@type'
        end

        n.name_role_pair :path => '.', :accessor => lambda { |node| node.roleTerm.text + ": " + node.namePart.text }

    #    n.name_object :path => '.', :accessor => lambda { |node| ModsName.new node }
      end

      t.language :path => 'mods:language' do |n|
        n.value :path => 'mods:languageTerm', :accessor => :text
      end
     
     end

     xml.nom!
     xml
  }

  it "should work with existing reserved method names when override is present" do
    expect(subject.author.first.description.text).to include('asdf')
  end

  it "should return nodesets by default" do
    expect(subject.personal_authors).to be_a_kind_of(Nokogiri::XML::NodeSet)
  end

  it "should return single elements on demand" do
    expect(subject.personal_authors.first.namePart).to be_a_kind_of(Nokogiri::XML::Element)
  end

  it "should return attributes as single-valued" do
    expect(subject.personal_authors.first.valueURI).to be_a_kind_of(Nokogiri::XML::Attr)
  end


  it "should treat attributes with an accessor as a single-able element" do
    expect(subject.author.first.authorityURI).to eq('http://id.loc.gov/authorities/names')
  end

  it "should share terms over matched nodes" do
    expect(subject.personal_authors.first.namePart.text).to eq("Alterman, Eric")
  end

  it "should return single elements out of nodesets correctly" do
    expect(subject.personal_authors.namePart).to be_a_kind_of(Nokogiri::XML::NodeSet)
  end

  it "should create enumerable objects" do
    expect(subject.personal_authors).to respond_to(:each)
    expect(subject.personal_authors.size).to eq(1)
  end

  it "should provide accessors" do
    eric =subject.personal_authors.first
 
    expect(eric.namePart.text).to eq("Alterman, Eric")
    expect(eric.roleTerm.text).to eq("creator")

    expect(eric.roleTerm._type.text).to eq("text")
  end

  it "should let you mix and match xpaths and nom accessors" do
    expect(subject.language.value).to include('eng')
    expect(subject.xpath('//mods:language', 'mods' => 'http://www.loc.gov/mods/v3').value).to include('eng')
  end

  it "should work with attributes" do
    eric =subject.personal_authors.first
    expect(eric.valueURI.to_s).to eq('http://id.loc.gov/authorities/names/n92101908')
  end

  it "should allow you to access a term from the node" do
    expect(subject.personal_authors.namePart.terms.map { |term|term.options[:index_as] }.flatten).to include(:type_1)
  end

  it "should allow you to use multiple terms to address the same node" do
    t = subject.xpath('//mods:name', subject.terminology.namespaces).first.terms
    expect(t.map { |x| x.name }).to include(:author, :personal_authors)
  end

  it "should let you go from a terminology to nodes" do
    expect(subject.terminology.flatten.length).to eq(14)

    expect(subject.terminology.flatten.select { |x| x.options[:index_as] }.size).to eq(2) 
    expect(subject.terminology.flatten.select { |x| x.options[:index_as] }.map { |x| x.nodes }.flatten.size).to eq(2)
  end

  it "should let you go from a term to a terminology" do
    expect(subject.personal_authors.terms.first.terminology).to eq(subject.terminology)
  end

end
