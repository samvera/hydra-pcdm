require 'spec_helper'

describe "Nutrition" do
  let(:file) { File.open(File.join(File.dirname(__FILE__), '..', 'fixtures', 'nutrition.xml'), 'r') }
  let(:xml) { Nokogiri::XML(file) }

  subject {
     xml.set_terminology do |t|
       t.unit_value :path => '.', :accessor => lambda { |node| "#{node.text}#{node['units']}" }, :global => true

       t.daily_values :path => 'daily-values' do |dv|
         dv.total_fat :path => 'total-fat' do |tf|
           tf.value :path => '.', :accessor => lambda { |node| node.text.to_i }
           tf.units :path => '@units'
           tf.units_if :path => '@units', :if => lambda { |node| true }
           tf.units_if_false :path => '@units', :if => lambda { |node| false }
         end
       end

       t.foods :path => 'food' do |food|
         food._name :path => 'name'
         food.mfr

         food.total_fat :path => 'total-fat' do |tf|
           tf.value :path => '.', :accessor => lambda { |node| node.text.to_i }
         end
       end
     end

     xml.nom!

     xml
  }

  it "should be able to access things via xpath, and then continue with terminology selectors" do
    expect(subject.xpath('//food').first._name.text).to eq("Avocado Dip")
  end

  it "should have total fat information" do
    expect(subject.daily_values.total_fat.text).to eq("65")
    expect(subject.daily_values.total_fat.value).to include(65)
    expect(subject.daily_values.total_fat.units.text).to eq('g')

    expect(subject.foods.total_fat.value.inject(:+)).to eq(117)
  end

  it "should have food names" do
    expect(subject.foods._name.text).to include("Avocado Dip")
  end

  it "should have xpath selectors" do
    expect(subject.foods(:name => 'Avocado Dip').total_fat.value.first).to eq(11)
    expect(subject.foods('total-fat/text() = 11')._name.text).to eq("Avocado Dip")
  end

  it "should have global terms" do
    expect(subject.daily_values.total_fat.unit_value).to include('65g')
    expect(subject.foods.first.at('serving').unit_value).to include('29g')
  end

  it "should accept if in proc-form" do
    subject.daily_values.total_fat.units_if == subject.daily_values.total_fat.units
    expect(subject.daily_values.total_fat.units_if_false).to be_empty
  end
end
