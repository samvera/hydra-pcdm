require 'spec_helper'

describe Hydra::PCDM do

  let(:coll1)  { Hydra::PCDM::Collection.create }
  let(:obj1)   { Hydra::PCDM::Object.create }
  let(:file1)  { Hydra::PCDM::File.new }

  describe 'Validations' do

    describe "#collection?" do
      it "should return true for a pcdm collection" do
        expect( Hydra::PCDM.collection? coll1 ).to be true
      end

      it "should return false for a pcdm object" do
        expect( Hydra::PCDM.collection? obj1 ).to be false
      end

      it "should return false for a pcdm file" do
        expect( Hydra::PCDM.collection? file1 ).to be false
      end
    end

    describe "#object?" do
      it "should return false for a pcdm collection" do
        expect( Hydra::PCDM.object? coll1 ).to be false
      end

      it "should return true for a pcdm object" do
        expect( Hydra::PCDM.object? obj1 ).to be true
      end

      it "should return false for a pcdm file" do
        expect( Hydra::PCDM.object? file1 ).to be false
      end
    end

    describe "#file?" do
      it "should return false for a pcdm collection" do
        expect( Hydra::PCDM.file? coll1 ).to be false
      end

      it "should return false for a pcdm object" do
        expect( Hydra::PCDM.file? obj1 ).to be false
      end

      it "should return true for a pcdm file" do
        expect( Hydra::PCDM.file? file1 ).to be true
      end
    end

  end

end
