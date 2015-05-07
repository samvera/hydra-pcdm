require 'spec_helper'

describe 'Hydra::PCDM::CreateCollection' do

  describe "#call" do
    it "should create a collection as recognized by Hydra::PCDM" do
      expect( Hydra::PCDM.collection? Hydra::PCDM::CreateCollection.call ).to be true
    end
  end

end
