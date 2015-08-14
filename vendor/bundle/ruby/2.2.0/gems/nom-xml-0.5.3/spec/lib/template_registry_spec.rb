require 'spec_helper'

describe "NOM::XML::TemplateRegistry" do

  let(:file) { '<people xmlns="urn:registry-test"><person title="Actor">Alice</person></people>' }
  let(:xml) { Nokogiri::XML(file) }
  let(:expectations) {
    {
      :before  => %{<people xmlns="urn:registry-test"><person title="Builder">Bob</person><person title="Actor">Alice</person></people>},
      :after   => %{<people xmlns="urn:registry-test"><person title="Actor">Alice</person><person title="Builder">Bob</person></people>},
      :instead => %{<people xmlns="urn:registry-test"><person title="Builder">Bob</person></people>}
    }
  }
  subject {
    xml.set_terminology(:namespaces => { 'default' => 'urn:registry-test' }) do |t|
      t.person(:xmlns => 'default') {
        t.title(:path => "@title")
      }
    end

    xml.define_template :person do |xml,name,title|
      xml.person(:title => title) do
        xml.text(name)
      end
    end

    xml.nom!

    xml
  }
  
  describe "template definitions" do
    it "should contain predefined templates" do
      expect(subject.template_registry.node_types).to include(:person)
      expect(subject.template_registry.node_types).not_to include(:zombie)
    end

    describe "ZOMG ZOMBIES!!11!!!1" do
      before(:each) do
        subject.define_template :zombie do |xml,name|
          xml.monster(:wants => 'braaaaainz') do
            xml.text(name)
          end
        end
      end
      it "should define new templates" do
        expect(subject.template_registry.node_types).to include(:zombie)
      end

      it "should instantiate a detached node from a template" do
        node = subject.template_registry.instantiate(:zombie, 'Zeke')
        expectation = Nokogiri::XML('<monster wants="braaaaainz">Zeke</monster>').root
        expect(node).to be_equivalent_to(expectation)
      end
      
      it "should raise an error when trying to instantiate an unknown node_type" do
        expect { subject.template_registry.instantiate(:demigod, 'Hercules') }.to raise_error(NameError)
      end
      
      it "should raise an exception if a missing method name doesn't match a node_type" do
        expect { subject.template_registry.demigod('Hercules') }.to raise_error(NameError)
      end
      
      it "should undefine existing templates" do
        expect(subject.template_registry.node_types).to include(:zombie)
        subject.template_registry.undefine :zombie
        expect(subject.template_registry.node_types).not_to include(:zombie)
      end
      
      it "should complain if the template name isn't a symbol" do
        expect { subject.template_registry.define("die!") { |xml| subject.this_never_happened } }.to raise_error(TypeError)
      end
      
      it "should report on whether a given template is defined" do
        expect(subject.template_registry.has_node_type?(:zombie)).to eq(true)
        expect(subject.template_registry.has_node_type?(:demigod)).to eq(false)
      end

    end    
  end
  
  describe "template-based document manipulations" do
    it "should accept a Nokogiri::XML::Node as target" do
      subject.template_registry.after(subject.root.elements.first, :person, 'Bob', 'Builder')
      expect(subject.root.elements.length).to eq(2)
    end

    it "should accept a Nokogiri::XML::NodeSet as target" do
      subject.template_registry.after(subject.root.elements, :person, 'Bob', 'Builder')
      expect(subject.root.elements.length).to eq(2)
    end
    
    it "should instantiate a detached node from a template using the template name as a method" do
      node = subject.template_registry.person('Odin', 'All-Father')
      expectation = Nokogiri::XML('<person title="All-Father">Odin</person>').root
      expect(node).to be_equivalent_to(expectation)
    end
    
    it "should add_child" do
      return_value = subject.template_registry.add_child(subject.root, :person, 'Bob', 'Builder')
      expect(return_value).to eq(subject.person[1])
      expect(subject).to be_equivalent_to(expectations[:after]).respecting_element_order
    end
    
    it "should add_next_sibling" do
      return_value = subject.template_registry.add_next_sibling(subject.person.first, :person, 'Bob', 'Builder')
      expect(return_value).to eq(subject.person[1])
      expect(subject).to be_equivalent_to(expectations[:after]).respecting_element_order
    end

    it "should add_previous_sibling" do
      return_value = subject.template_registry.add_previous_sibling(subject.person.first, :person, 'Bob', 'Builder')
      expect(return_value).to eq(subject.person.first)
      expect(subject).to be_equivalent_to(expectations[:before]).respecting_element_order
    end

    it "should after" do
      return_value = subject.template_registry.after(subject.person.first, :person, 'Bob', 'Builder')
      expect(return_value).to eq(subject.person.first)
      expect(subject).to be_equivalent_to(expectations[:after]).respecting_element_order
    end

    it "should before" do
      return_value = subject.template_registry.before(subject.person.first, :person, 'Bob', 'Builder')
      expect(return_value).to eq(subject.person[1])
      expect(subject).to be_equivalent_to(expectations[:before]).respecting_element_order
    end

    it "should replace" do
      target_node = subject.person.first
      return_value = subject.template_registry.replace(target_node, :person, 'Bob', 'Builder')
      expect(return_value).to eq(subject.person.first)
      expect(subject).to be_equivalent_to(expectations[:instead]).respecting_element_order
    end

    it "should swap" do
      target_node = subject.person.first
      return_value = subject.template_registry.swap(target_node, :person, 'Bob', 'Builder')
      expect(return_value).to eq(target_node)
      expect(subject).to be_equivalent_to(expectations[:instead]).respecting_element_order
    end
    
    it "should yield the result if a block is given" do
      target_node = subject.person.first
      expectation = Nokogiri::XML('<person xmlns="urn:registry-test" title="Actor">Alice</person>').root
      expect(subject.template_registry.swap(target_node, :person, 'Bob', 'Builder') { |old_node|
        expect(old_node).to be_equivalent_to(expectation)
        old_node
      }).to be_equivalent_to(expectation)
    end
  end
    
  describe "document-based document manipulations" do
    it "should accept a Nokogiri::XML::Node as target" do
      subject.root.elements.first.after_person('Bob', 'Builder')
      expect(subject.root.elements.length).to eq(2)
    end

    it "should accept a Nokogiri::XML::NodeSet as target" do
      subject.person.after_person(:person, 'Bob', 'Builder')
      expect(subject.root.elements.length).to eq(2)
    end
    
    it "should instantiate a detached node from a template" do
      node = subject.template_registry.instantiate(:person, 'Odin', 'All-Father')
      expectation = Nokogiri::XML('<person title="All-Father">Odin</person>').root
      expect(node).to be_equivalent_to(expectation)
    end

    it "should add_child_node" do
      return_value = subject.root.add_child_person('Bob', 'Builder')
      expect(return_value).to eq(subject.person[1])
      expect(subject).to be_equivalent_to(expectations[:after]).respecting_element_order
    end
    
    it "should add_next_sibling_node" do
      return_value = subject.person[0].add_next_sibling_person('Bob', 'Builder')
      expect(return_value).to eq(subject.person[1])
      expect(subject).to be_equivalent_to(expectations[:after]).respecting_element_order
    end

    it "should add_previous_sibling_node" do
      return_value = subject.person[0].add_previous_sibling_person('Bob', 'Builder')
      expect(return_value).to eq(subject.person.first)
      expect(subject).to be_equivalent_to(expectations[:before]).respecting_element_order
    end

    it "should after_node" do
      return_value = subject.person[0].after_person('Bob', 'Builder')
      expect(return_value).to eq(subject.person.first)
      expect(subject).to be_equivalent_to(expectations[:after]).respecting_element_order
    end

    it "should before_node" do
      return_value = subject.person[0].before_person('Bob', 'Builder')
      expect(return_value).to eq(subject.person[1])
      expect(subject).to be_equivalent_to(expectations[:before]).respecting_element_order
    end

    it "should replace_node" do
      target_node = subject.person.first
      return_value = target_node.replace_person('Bob', 'Builder')
      expect(return_value).to eq(subject.person.first)
      expect(subject).to be_equivalent_to(expectations[:instead]).respecting_element_order
    end

    it "should swap_node" do
      target_node = subject.person.first
      return_value = target_node.swap_person('Bob', 'Builder')
      expect(return_value).to eq(target_node)
      expect(subject).to be_equivalent_to(expectations[:instead]).respecting_element_order
    end
  end
  
end
