require 'spec_helper'

describe 'Hydra::PCDM::Collection' do

  # subject { Hydra::PCDM::Collection.new }

  describe '#members' do

    # let(:collection1) { Hydra::PCDM::Collection.create(id: 'col1') }
    # let(:collection2) { Hydra::PCDM::Collection.create(id: 'col2') }

    # TODO: Ultimately, a call to this method should FAIL
    #       The call should go to collections or objects.
    #       But to test initial plumbing, no restrictions are being applied and anything can be added to members.
    it 'should add anything as a member' do
binding.pry

      cnew = Hydra::PCDM::Collection.new
      collection1 = Hydra::PCDM::Collection.create(id: 'col1')
      collection2 = Hydra::PCDM::Collection.create(id: 'col1')


      collection1.members = [collection2]
      # collection1.save
      expect(collection1.members).to eq [collection2]
    end

  end


  #   1) PCDM::Collection can aggregate PCDM::Collection
  #   2) PCDM::Collection can aggregate PCDM::Object
  #   3) PCDM::Collection can NOT contain PCDM::File


end
