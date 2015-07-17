module Hydra::PCDM
  module ChildObjects
    def child_object_ids
      child_objects.map(&:id)
    end

    def objects= objects
      warn "[DEPRECATION] `objects=` is deprecated.  Please use `child_objects=` instead.  This has a target date for removal of 07-31-2015"
      self.child_objects= objects
    end

    def objects
      warn "[DEPRECATION] `objects` is deprecated.  Please use `child_objects` instead.  This has a target date for removal of 07-31-2015"
      self.child_objects
    end
  end
end

