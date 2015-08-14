require 'spec_helper'

describe Hydra::PCDM do
  let(:coll1)  { Hydra::PCDM::Collection.create }
  let(:obj1)   { Hydra::PCDM::Object.create }
  let(:file1)  { Hydra::PCDM::File.new }

  describe 'Validations' do
    describe '#collection?' do
      it 'return true for a pcdm collection' do
        expect(described_class.collection? coll1).to be true
      end

      it 'return false for a pcdm object' do
        expect(described_class.collection? obj1).to be false
      end

      it 'return false for a pcdm file' do
        expect(described_class.collection? file1).to be false
      end
    end

    describe '#object?' do
      it 'return false for a pcdm collection' do
        expect(described_class.object? coll1).to be false
      end

      it 'return true for a pcdm object' do
        expect(described_class.object? obj1).to be true
      end

      it 'return false for a pcdm file' do
        expect(described_class.object? file1).to be false
      end
    end

    describe '#file?' do
      it 'return false for a pcdm collection' do
        expect(described_class.file? coll1).to be false
      end

      it 'return false for a pcdm object' do
        expect(described_class.file? obj1).to be false
      end

      it 'return true for a pcdm file' do
        expect(described_class.file? file1).to be true
      end
    end
  end
end
