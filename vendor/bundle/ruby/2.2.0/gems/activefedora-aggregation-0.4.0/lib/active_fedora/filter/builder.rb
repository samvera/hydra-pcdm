module ActiveFedora::Filter
  class Builder < ActiveFedora::Associations::Builder::CollectionAssociation
    self.macro = :filter
    self.valid_options = [:extending_from, :condition]

    def self.define_readers(mixin, name)
      super
      mixin.redefine_method("#{name.to_s.singularize}_ids") do
        association(name).ids_reader
      end
    end
  end
end

