module Hydra
  module PCDM
    class Collection < ActiveFedora::Base
      # include Hydra::PCDM::CollectionInterface

# binding.pry

      type = RDFVocabularies::PCDMTerms.Collection
      aggregates :members

# binding.pry
# puts "after break"

#       def self.create *args
# # binding.pry
#         super args
#       end
    end
  end
end

