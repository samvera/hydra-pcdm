require 'spec_helper'

describe Hydra::PCDM::Collection do

  let(:collection1) { Hydra::PCDM::Collection.create }
  let(:collection2) { Hydra::PCDM::Collection.create }
  let(:collection3) { Hydra::PCDM::Collection.create }

  let(:object1) { Hydra::PCDM::Object.create }
  let(:object2) { Hydra::PCDM::Object.create }

  describe '#collections=' do
    it 'should aggregate collections' do
      collection1.collections = [collection2, collection3]
      collection1.save
      expect(collection1.collections).to eq [collection2, collection3]
    end
  end

  describe '#objects=' do
    it 'should aggregate objects' do
      collection1.objects = [object1,object2]
      collection1.save
      expect(collection1.objects).to eq [object1,object2]
    end
  end

  describe 'Related objects' do
    let(:object1)     { Hydra::PCDM::Object.create }
    let(:collection1) { Hydra::PCDM::Collection.create }

    before do
      collection1.related_objects = [object1]
      collection1.save
    end

    it 'persists' do
      expect(collection1.reload.related_objects).to eq [object1]
    end
  end

end
