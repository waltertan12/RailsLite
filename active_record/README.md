# Active Record Lite
This is a reimplementation of some of ActiveRecord's core features, namely, model persistence, querying, and basic associations.

### Models
Just like in Ruby on Rails, you can create normal ruby classes that inherit from ActiveRecordBase. Simply define the classes using the following format:
````ruby
class ClassName < ActiveRecordBase
  # You can write model level validations using the ActiveRecordBase#validates method.
  # Currently, ActiveRecordBase#validates can only check for uniqueness, presence, and length
  # Simply write it in this form
  validates :column_name, presence: true
  validates :column_name, length: {minimum: 8}
  validates :column_name, uniqueness: true
end
````
Unlike normal Rails, you cannot write an #initialize method in the class. The columns you declare in the `db/schema.sql` file dictates the instance variables in each class.