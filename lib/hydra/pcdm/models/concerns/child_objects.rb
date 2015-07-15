module Hydra::PCDM
  module ChildObjects
    def child_objects= objects
      raise ArgumentError, "each object must be a pcdm object" unless objects.all? { |o| Hydra::PCDM.object? o }
      raise ArgumentError, "an object can't be an ancestor of itself" if object_ancestor?(objects)
      self.members = objects
    end

    def objects= objects
      warn "[DEPRECATION] `objects=` is deprecated.  Please use `child_objects=` instead.  This has a target date for removal of 07-31-2015"
      self.child_objects= objects
    end

    def child_objects
      members.to_a.select { |m| Hydra::PCDM.object? m }
    end

    def child_object_ids
      child_objects.map(&:id)
    end

    def objects
      warn "[DEPRECATION] `objects` is deprecated.  Please use `child_objects` instead.  This has a target date for removal of 07-31-2015"
      self.child_objects
    end


  end
end
