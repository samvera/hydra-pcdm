# This module is mixed into classes that declare 'aggregates ...'
#
module ActiveFedora::Aggregation
  module AggregationExtension
    extend ActiveSupport::Concern
    include PersistLinks

    included do
      after_destroy :remove_aggregation_proxies_from_solr

      # Doesn't use after_save because we need this callback to come after the autosave callback
      after_create :persist_aggregation_links
      after_update :persist_aggregation_links
    end

    private

      # The proxies, being nested under the object, are automatically destroyed
      # this cleans up their records from solr.
      def remove_aggregation_proxies_from_solr
        query = ActiveFedora::SolrQueryBuilder.construct_query_for_rel(proxyIn: id, has_model: Proxy.to_class_uri)
        ActiveFedora::SolrService.instance.conn.delete_by_query(query, params: {'softCommit' => true})
      end

  end
end
