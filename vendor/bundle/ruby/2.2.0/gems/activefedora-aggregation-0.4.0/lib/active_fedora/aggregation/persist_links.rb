module ActiveFedora::Aggregation
  module PersistLinks
    # If the head or tail pointer was updated (in an autosave callback), then persist them
    def persist_aggregation_links
      return true unless @new_record_before_save
      save if changes.key?("head_id") or changes.key?("tail_id")
    end
  end
end
