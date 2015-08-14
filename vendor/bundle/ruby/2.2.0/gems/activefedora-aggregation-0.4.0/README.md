[![Gem Version](https://badge.fury.io/rb/activefedora-aggregation.svg)](http://badge.fury.io/rb/activefedora-aggregation) [![Build Status](https://circleci.com/gh/projecthydra-labs/activefedora-aggregation.svg?style=shield&circle-token=:circle-token)](https://circleci.com/gh/projecthydra-labs/activefedora-aggregation)
# ActiveFedora::Aggregation

Aggregations for ActiveFedora: manage a group of related objects using predicates from the
[OAI-ORE data model](http://www.openarchives.org/ore/1.0/datamodel).  Provides the foundation
for flexible relationships, including items appearing multiple times in a group,
flexible/optional ordering, etc.

Used extensively by [Hydra::PCDM](https://github.com/projecthydra-labs/hydra-pcdm/).

### Example
```ruby
class GenericFile < ActiveFedora::Base
end

generic_file1 = GenericFile.create(id: 'file1')
generic_file2 = GenericFile.create(id: 'file2')

class Image < ActiveFedora::Base
  aggregates :generic_files
end

image = Image.create(id: 'my_image')
image.generic_files = [generic_file2, generic_file1]
image.save

```

Now the `generic_files` method returns an ordered list of GenericFile objects.
