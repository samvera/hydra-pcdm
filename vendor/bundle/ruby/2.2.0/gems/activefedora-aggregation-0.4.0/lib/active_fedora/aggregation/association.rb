module ActiveFedora::Aggregation
  class Association < ::ActiveFedora::Associations::IndirectlyContainsAssociation
    delegate :first, to: :ordered_reader

    def ordered_reader
      OrderedReader.new(owner).to_a
    end

    def proxy_class
      @proxy_class ||= ProxyRepository.new(owner, super)
    end

    def options
      @all_options ||= default_options.merge(super)
    end

    # Implements the ids reader method, e.g. foo.item_ids for Foo.has_many :items
    def ids_reader
      if loaded?
        load_target.map do |record|
          record.id
        end
      else
        proxies = load_proxies_from_solr(fl: 'id, next_ssim, proxyFor_ssim')
        create_linked_list(@owner.head_id, proxies)
      end
    end

    private

    # Write a query to find the proxies
    def construct_proxy_query
      @proxy_query ||= begin
        clauses = { 'proxyIn' => @owner.id }
        clauses[:has_model] = ActiveFedora::Aggregation::Proxy.to_class_uri
        ActiveFedora::SolrQueryBuilder.construct_query_for_rel(clauses)
      end
    end

    # Finds the proxies
    # @param opts [Hash] Options that will be passed through to ActiveFedora::SolrService.query.
    def load_proxies_from_solr(opts = Hash.new)
      finder_query = construct_proxy_query
      rows = 1000
      ActiveFedora::SolrService.query(finder_query, { rows: rows }.merge(opts))
    end

    # @param [String, NilClass] first_id
    # @param [Array<Hash>] remainder
    # @param [Array] list
    def create_linked_list(first_id, remainder, list=[])
      return list if remainder.empty?

      index = remainder.find_index { |n| n.fetch('id') == first_id }
      first = remainder.delete_at(index)
      next_id = first['next_ssim'].try(:first)
      create_linked_list(next_id, remainder, list + [first.fetch('proxyFor_ssim').first])
    end

    def default_options
      { through: default_proxy_class, foreign_key: :target, has_member_relation: reflection.predicate, inserted_content_relation: content_relation }
    end

    def content_relation
      default_proxy_class.constantize.reflect_on_association(:target).predicate
    end

    def default_proxy_class
      'ActiveFedora::Aggregation::Proxy'
    end

  end
end
