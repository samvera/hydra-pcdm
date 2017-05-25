describe Hydra::PCDM::CollectionIndexer do
  let(:collection) { Hydra::PCDM::Collection.new }
  let(:collection_ids) { %w(123 456) }
  let(:object_ids) { ['789'] }
  let(:member_ids) { %w(123 456 789) }
  let(:indexer) { described_class.new(collection) }

  before do
    allow(collection).to receive(:ordered_collection_ids).and_return(collection_ids)
    allow(collection).to receive(:ordered_object_ids).and_return(object_ids)
    allow(collection).to receive(:member_ids).and_return(member_ids)
  end

  describe '#generate_solr_document' do
    subject { indexer.generate_solr_document }

    it 'has fields' do
      expect(subject[Hydra::PCDM::Config.indexing_collection_ids_key]).to eq %w(123 456)
      expect(subject[Hydra::PCDM::Config.indexing_object_ids_key]).to eq ['789']
      expect(subject[Hydra::PCDM::Config.indexing_member_ids_key]).to eq %w(123 456 789)
    end

    context 'with block passed' do
      it 'returns the same document' do
        expect(indexer.generate_solr_document { |_doc| }).to eq subject
      end
      it 'yields the same document that it otherwise returns' do
        expect { |b| indexer.generate_solr_document(&b) }.to yield_with_args(subject)
      end
    end

    context 'when extended in the conventional way' do
      let(:indexer) { extender.new(collection) }
      let(:extender) do
        Class.new(described_class) do
          def generate_solr_document
            super.tap { |doc| doc['my_special_field'] = 66 }
          end
        end
      end

      context 'with block passed' do
        it 'returns the same document' do
          expect(indexer.generate_solr_document { |_doc| }).to eq indexer.generate_solr_document
        end
        it 'yields the same document that it otherwise returns' do
          expect { |b| indexer.generate_solr_document(&b) }.to yield_with_args(a_hash_including('my_special_field' => 66))
          expect { |b| indexer.generate_solr_document(&b) }.to yield_with_args(indexer.generate_solr_document)
        end
      end
    end
  end
end
